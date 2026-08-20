export class AppError extends Error {
  public readonly statusCode: number;
  public readonly isOperational: boolean;

  constructor(message: string, statusCode: number = 500, isOperational: boolean = true) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = isOperational;
    Object.setPrototypeOf(this, new.target.prototype);
    Error.captureStackTrace(this, this.constructor);
  }
}

export class NetworkError extends AppError {
  constructor(message: string = 'Lỗi kết nối mạng. Vui lòng kiểm tra lại đường truyền.') {
    super(message, 503, true);
  }
}

export class NotFoundError extends AppError {
  constructor(message: string = 'Không tìm thấy dữ liệu phim yêu cầu.') {
    super(message, 404, true);
  }
}

export class TimeoutError extends AppError {
  constructor(message: string = 'Kết nối tới máy chủ phim.nguonc.com quá thời gian chờ (10s).') {
    super(message, 408, true);
  }
}
