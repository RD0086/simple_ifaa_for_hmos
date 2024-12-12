import deviceInfo from '@ohos.deviceInfo';

/**
 * 获取设备认证型号
 * @returns 认证型号
 */
export function getProductModel(): string {
  let productModel: string = deviceInfo.productModel;
  return productModel;
}
