import router from '@ohos.router';
@Entry
@Component
struct Result {
  @State message: string = "";
  @State code: number = -1;
  aboutToAppear(): void {
    if (router.getParams() !== undefined && router.getParams() !== null) {
      let record = router.getParams() as Record<string, string>;
      if (record !== undefined && record !== null) {
        this.message = record['message']
        this.code = parseInt(record['code'])
        console.info('接收到前一个页面的参数：', JSON.stringify(record))
      }
    }
  }
  build() {
    Column() {
      Row(){
        if(this.code == 0){
          Image($r('app.media.success_icon')).width('auto').height('100%')
        }else{
          Image($r('app.media.failed_icon')).width('auto').height('100%')
        }
      }.width('80%').height('35%').padding({top: '80vp', bottom: '20vp'}).justifyContent(FlexAlign.Center)
      Row(){
        if(this.code == 0){
          Text('认证成功').fontSize('30fp')
        }else{
          Text('认证失败').fontSize('30fp')
        }
      }.width('80%').justifyContent(FlexAlign.Center)
      if(this.code > 0){
        Column(){
          Row() {
            Text('code: ' + this.code.toString())
          }
          Row() {
            Text('msg: ' + this.message)
          }
        }
        .width('80%').height('25%')
        .padding({top: '5%', left: '5%', bottom: '5%', right: '5%'})
        .border({radius: '20vp'}).backgroundColor('#fff1f1f1')
        .alignItems(HorizontalAlign.Start)
        .margin({top:'20vp',bottom:'15%'})
      }else{
        Column(){
        }
        .width('80%').height('25%')
        .padding({top: '5%', left: '5%', bottom: '5%', right: '5%'})
        .backgroundColor('#FFFFFF')
        .alignItems(HorizontalAlign.Start)
        .margin({top:'20vp',bottom:'10%'})
      }
      Row(){
        Button('确定').onClick(async () => {
          router.pushUrl({
            url: "pages/Index",
          })
        }).width('100%').fontSize('20fp').height('45vp')
      }.width('80%').margin({bottom: '20vp'}).justifyContent(FlexAlign.Center)
    }
    .height('100%').width('100%').padding({top: '15%'})
  }
}