export enum LogLevel {
  DEBUG = 'DEBUG',
  INFO = 'INFO',
  WARN = 'WARN',
  ERROR = 'ERROR',
}

export class LoggerService {
  private static instance: LoggerService;

  private constructor() {}

  public static getInstance(): LoggerService {
    if (!LoggerService.instance) {
      LoggerService.instance = new LoggerService();
    }
    return LoggerService.instance;
  }

  public log(level: LogLevel, message: string, meta?: any): void {
    const timestamp = new Date().toISOString();
    const formatted = `[${timestamp}] [${level}] ${message}`;

    switch (level) {
      case LogLevel.DEBUG:
        console.debug(formatted, meta || '');
        break;
      case LogLevel.INFO:
        console.info(formatted, meta || '');
        break;
      case LogLevel.WARN:
        console.warn(formatted, meta || '');
        break;
      case LogLevel.ERROR:
        console.error(formatted, meta || '');
        break;
    }
  }

  public debug(message: string, meta?: any): void {
    this.log(LogLevel.DEBUG, message, meta);
  }

  public info(message: string, meta?: any): void {
    this.log(LogLevel.INFO, message, meta);
  }

  public warn(message: string, meta?: any): void {
    this.log(LogLevel.WARN, message, meta);
  }

  public error(message: string, meta?: any): void {
    this.log(LogLevel.ERROR, message, meta);
  }
}

export const logger = LoggerService.getInstance();
