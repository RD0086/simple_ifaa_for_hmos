/**
 * 错误码枚举
 */
export enum SIfaaErrorCode {
  /**
   * 成功
   */
  SUCCESS = 0,
  /**
   * 终端不支持 IFAA
   */
  STATUS_NOT_SUPPORT = 1,
  /**
   * 没有录入指纹
   */
  STATUS_NOT_ENROLLED = 4,
  /**
   * 未注册
   */
  STATUS_NOT_REGISTERED = 5,
  /**
   * IFAA 已经注册 (checkStatusInit中返回，表示已经是注册状态，无需发送请求到服务端查询)
   */
  STATUS_REGISTERED = 6,
  /**
   * SDK本地执行异常
   */
  CLIENT_ERROR = 8,
  /**
   * IFAA服务错误
   */
  SERVER_ERROR = 9,
  /**
   * 指纹不匹配，需要更新指纹（authFinish中返回时，进行更新指纹流程）
   */
  WRONG_AUTHDATAINDEX = 11,
  /**
   * 被风险策略拒绝时（IFAA服务端返回）
   */
  POLICY_REJECTED = 12,
  /**
   * 用户被禁用时（IFAA服务端返回）
   */
  USER_REJECTED = 13,
  /**
   * 应用标识白名单中未设置，需要在IFAA服务端添加该应用标识（IFAA服务端返回）
   */
  APPID_NOT_FOUND = 14,
  /**
   * 设备型号不存在（IFAA服务端返回）
   */
  DEVICE_MODEL_NOT_FOUND = 15,
  /**
   * 未获取到签名数据（IFAA服务端返回）
   */
  ERR_SIGNATURE_FAIL = 16,
  /**
   * 用户取消
   */
  STATUS_RESULT_CANCELED = 19,
  /**
   * 认证流程开始时，长时间未进行生物认证，认证超时
   */
  STATUS_RESULT_TIMEOUT = 20,
  /**
   * 验证失败，生物认证不匹配
   */
  STATUS_RESULT_AUTH_FAIL = 21,
  /**
   * 连续多次校验失败，指纹校验被暂时锁定
   */
  STATUS_RESULT_SYSTEM_BLOCK = 22,
  /**
   * 点击了 FALLBACK 按钮
   */
  STATUS_RESULT_FALLBACK = 23,
  /**
   * TEE 错误
   */
  STATUS_RESULT_SYSTEM_ERROR = 24,
  /**
   * 手机没有相机权限
   */
  PERMISSION_DENIED = 26,
  /**
   * 认证器被禁用（IFAA服务端返回）
   */
  AUTHENTICATOR_DISABLE = 27,
  /**
   * 未找到相应的认证器（IFAA服务端返回）
   */
  AUTHENTICATOR_NOT_FOUND = 28,
  /**
   * 设备密钥被禁用（IFAA服务端返回）
   */
  DEVICE_KEY_NOT_FOUND = 29,
}

/**
 * 执行结果回调
 */
export class SIfaaResponse {
  /**
   * 执行结果码
   */
  public code: SIfaaErrorCode = SIfaaErrorCode.CLIENT_ERROR;
  /**
   * 执行结果描述
   */
  public msg:string = '异常';
  /**
   * 返回的数据
   */
  public data:string = '';

  constructor() {

  }

  initWithCode(code: SIfaaErrorCode, msg: string) {
    this.code = code;
    this.msg = msg;
  }
}


export class SIfaaAuthorizationResBean {
  action?: string
  transId?:string
  identifyData?:string
  code:string = ""
  msg:string = ""
}