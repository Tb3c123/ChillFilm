import { AppError } from './AppError';
import { logger } from '../services/LoggerService';

export class ErrorHandler {
  public static handle(error: unknown): { message: string; statusCode: number } {
    if (error instanceof AppError) {
      logger.warn(`[Operational Error] ${error.statusCode} - ${error.message}`);
      return { message: error.message, statusCode: error.statusCode };
    }

    if (error instanceof Error) {
      logger.error(`[Unexpected Error] ${error.message}`, error.stack);
      return { message: 'Đã xảy ra lỗi không xác định. Vui lòng thử lại sau.', statusCode: 500 };
    }

    logger.error('[Unknown Exception]', error);
    return { message: 'Đã xảy ra sự cố hệ thống.', statusCode: 500 };
  }
}
