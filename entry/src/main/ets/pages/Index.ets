import '@esand/sIfaaSDK';
import { SIFAAManager ,IfaaContext, IfaaErrorCodeEnum} from '@esand/sIfaaSDK';
import Logger from '../utils/Logger';
import {SIfaaRequest} from '../constants/SIfaaRequest'
import { HttpUtils } from  '../utils/HttpUtils'
import {SIfaaErrorCode, SIfaaAuthorizationResBean} from '../constants/SIfaaResponse'
import router from '@ohos.router';


const TAG = '[Index]';


@Entry
@Component
struct Index {
  @State message: string = '';
  @State url:string = "http://ifaa.dev.esandcloud.com";
  @State textAreaLog: string = "";
  @State code: number = -1;
  @State textValue: string = ''
  @State inputValue: string = 'click me'
  saveLog(msg: string) {
    let date1 = new Date();
    this.textAreaLog = `${this.textAreaLog}\n [${date1.toLocaleString()}] ${msg}`;
    Logger.info(TAG, msg);
  }

  build() {
    Column() {
      Row(){
        Image($r('app.media.index_icon2')).width('100%').height('auto')
      }.width('80%').padding({top: '80vp', bottom: '20vp'})
      Row(){
        Text('IFAA认证').fontSize('30fp')
      }.width('80%').justifyContent(FlexAlign.Center).margin({bottom:'60%'})
      Row(){
        Button('开始认证').onClick(async () => {
          this.code = -1;
          this.message = "";
          let sIFAAManager = new SIFAAManager()
          //查询当前设备支持的IFAA生物认证以及生物信息录入状态
          let supportBIOList = await sIFAAManager.getSupportBIOList();
          console.info("支持的生物认证类型", supportBIOList)
          if(supportBIOList.length > 0){
            //初始化
            let authType = supportBIOList[0].authType;
            let initRes = await sIFAAManager.sAuthInit(authType)
            if(initRes.code == IfaaErrorCodeEnum.SUCCESS){ //成功
              let ifaaInitMsg = initRes.data;
              //请求服务器获取授权证书
              let initData:SIfaaRequest = {
                "ifaaMsg" : ifaaInitMsg
              }
              let res = await HttpUtils.request(this.url + "/ifaa/hmos/sInit", JSON.stringify(initData));
              Logger.info(TAG,"初始化 httpInit", res)
              if(res){
                let resObj:SIfaaAuthorizationResBean = JSON.parse(res);
                if(resObj.code == "0000" && resObj.identifyData){
                  let identifyData = resObj.identifyData
                  //认证
                  let ifaaContext = new IfaaContext();
                  ifaaContext.authType = authType;
                  let authRes = await sIFAAManager.sAuth(ifaaContext, identifyData);
                  if(authRes.code == IfaaErrorCodeEnum.SUCCESS){
                    let authMsg = authRes.data;
                    let verifyData:SIfaaRequest = {
                      "ifaaMsg" : authMsg
                    }
                    //获取认证结果
                    let verifyRes = await HttpUtils.request(this.url + "/ifaa/hmos/sAuth", JSON.stringify(verifyData));
                    let verifyResObj:SIfaaAuthorizationResBean = JSON.parse(verifyRes);
                    if(verifyResObj.code == "0000"){
                      this.code = SIfaaErrorCode.SUCCESS;
                      this.message = "成功"
                    }else{
                      this.code = SIfaaErrorCode.ERR_SIGNATURE_FAIL;
                      this.message = "获取认证结果-" + JSON.stringify(verifyResObj)
                    }
                  }else{
                    this.code = authRes.code;
                    this.message = authRes.msg;
                  }
                }else{
                  this.code = SIfaaErrorCode.ERR_SIGNATURE_FAIL;
                  this.message = "请求服务器初始化-" + JSON.stringify(res)
                }
              }else{
                this.code = SIfaaErrorCode.ERR_SIGNATURE_FAIL;
                this.message = "获取授权的数据为空"
              }
            }else{
              this.code = initRes.code;
              this.message = "初始化-" + initRes.msg
            }
          }else{
            this.code = SIfaaErrorCode.STATUS_NOT_SUPPORT;
            this.message = "没有支持的生物认证类型"
          }
          router.pushUrl({
            url: "pages/Result",
            params: {
              code: this.code.toString(),
              message: this.message,
            }
          })
        }).width('100%').fontSize('20fp').height('45vp')
      }.width('80%').margin({bottom: '20vp'}).justifyContent(FlexAlign.Center)
    }
    .height('100%').width('100%').padding({top: '15%'})
  }
}