SECRET_KEY = "{{SEAHUB_SECRET_KEY}}"

FILE_SERVER_ROOT = 'http://{{SEAFILE_HOST}}/seafhttp'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.{{DB_ADAPTER}}',
        'NAME': '{{SEAHUB_DB_NAME}}',
        'USER': '{{DB_USER}}',
        'PASSWORD': '{{DB_PASS}}',
        'HOST': '{{DB_HOST}}',
        'PORT': '{{DB_PORT}}'
    }
}

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '127.0.0.1:11211',
    }
}

EMAIL_USE_TLS = {{SMTP_TLS}}
EMAIL_HOST = '{{SMTP_HOST}}'
EMAIL_HOST_USER = '{{SMTP_USER}}'
EMAIL_HOST_PASSWORD = '{{SMTP_PASS}}'
EMAIL_PORT = {{SMTP_PORT}}
DEFAULT_FROM_EMAIL = '{{SEAFILE_EMAIL}}'
SERVER_EMAIL = '{{SEAFILE_EMAIL}}'
