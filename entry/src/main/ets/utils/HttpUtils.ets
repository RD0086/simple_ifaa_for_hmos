
import http from '@ohos.net.http';

export class HttpUtils{

  static async request(url:string,data:string): Promise<string>{
    console.info("请求参数：", url, data)
    return new Promise((resolve,reject)=>{
      let httpRequest = http.createHttp();
      httpRequest.request(// 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
        url,
        {
          method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
          // 开发者根据自身业务需要添加header字段
          header: {
            'Content-Type': 'application/json'
          },
          // 当使用POST请求时此字段用于传递内容
          extraData: JSON.parse(data),
          connectTimeout: 3000, // 可选，默认为60000ms
          readTimeout: 3000, // 可选，默认为60000ms
        }, (err, data) => {
        if (!err) {
          // data.result为HTTP响应内容，可根据业务需要进行解析
          console.info('Result:' + data.result);
          console.info('code:' + JSON.stringify(data.responseCode));
          // data.header为HTTP响应头，可根据业务需要进行解析
          console.info('header:' + JSON.stringify(data.header));
          console.info('cookies:' + JSON.stringify(data.cookies)); // 8+
          resolve(data.result as string);
        } else {
          console.info('error:' + JSON.stringify(err));
          // 取消订阅HTTP响应头事件
          httpRequest.off('headersReceive');
          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy();
          reject(err);
        }
      }
      );
    });
  }
}