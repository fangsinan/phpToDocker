# 可以直接使用 fangsinan/php82-swoole 镜像
## 使用官方PHP镜像作为基础镜像
#FROM fangsinan/php82-swoole
#
#CMD ["php-fpm"]

## 使用官方PHP镜像作为基础镜像
FROM php:8.2-fpm


# 使用镜像源 阿里云  根据网络环境配置
RUN echo "deb http://mirrors.aliyun.com/debian bookworm main" > /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/debian-security bookworm-security main" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/debian bookworm-updates main" >> /etc/apt/sources.list


# 安装必要的系统软件包
RUN apt-get update && apt-get install -y \
    curl \
    git \
    libpng-dev libfreetype6-dev libjpeg-dev libwebp-dev libxpm-dev libxpm4 zlib1g-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libz-dev \
    libssl-dev \
    zip \
    unzip \
    iputils-ping \
    cups-client \
    vim \
    libmagickwand-dev \
    imagemagick \
    expect \
    iputils-ping \
    procps


RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# 安装PHP扩展
RUN docker-php-ext-install pdo_mysql mbstring xml zip bcmath gd intl pcntl
RUN pecl install imagick redis swoole \
     && docker-php-ext-enable imagick redis swoole


# 清除缓存
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


# 工作目录
WORKDIR /www

# 安装Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# 将Composer的全局二进制文件添加到PATH
ENV PATH="/composer/vendor/bin:${PATH}"
# 设置代理
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

CMD ["php-fpm"]
# 启动 PHP  容器
#目录挂载 /Users/sinan/ruidao
#docker run -it --rm -v $(pwd):/www -p 8000:8000 --name laravel-php74 laravel-php74 php artisan serve --host=0.0.0.0 --port=8000
#docker run -it -d -v /Users/sinan/ruidao/projects:/www -p 8000:8000 --name laravel-php74 laravel-php74 /bin/bash