import Logger from '../utils/Logger';
import common from '@ohos.app.ability.common';
import dataPreferences from '@ohos.data.preferences';
import { BusinessError } from '@ohos.base';

const TAG = '[DataPreferencesUtil]';
let preferences: dataPreferences.Preferences | null = null;


export class DataPreferencesUtil {
  // The preferences file name
  private dataPreferencesName = 'IfaaApplication';

  /**
   * 构造函数
   * @param context 上下文
   */
  constructor(context: common.UIAbilityContext) {
    try {
      let options: dataPreferences.Options = { name: this.dataPreferencesName };
      preferences = dataPreferences.getPreferencesSync(context, options);

    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      console.error(`Failed to get preferences. Code:${code},message:${message}`);
    }

  }

  /**
   * 保存数据
   * @param key 键
   * @param value 值
   * @returns
   */
  saveData(key: string, value: string): boolean {
    try {
      preferences?.putSync(key, value);
      preferences?.flush();
      return true;
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      Logger.error(TAG, `Failed to check the key 'startup'. Code:${code}, message:${message}`);
      return false;
    }
  }


  /**
   * 获取数据
   * @param key 键
   * @returns 值，可能为null或""
   */
  getDate(key: string): string {
    try {
      let val = preferences?.getSync(key, null) as string;
      Logger.info(TAG, `Succeeded in getting value of 'startup'. val: ${val}.`);
      return val;
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      Logger.error(TAG, `Failed to get value of 'startup'. Code:${code}, message:${message}`);
      return "";
    }
  }
}