SECRET_KEY = "{{SEAHUB_SECRET_KEY}}"

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

EMAIL_USE_TLS = {{SMTP_TLS}}
EMAIL_HOST = '{{SMTP_HOST}}'
EMAIL_HOST_USER = '{{SMTP_USER}}'
EMAIL_HOST_PASSWORD = '{{SMTP_PASS}}'
EMAIL_PORT = {{SMTP_PORT}}
DEFAULT_FROM_EMAIL = '{{SEAFILE_EMAIL}}'
SERVER_EMAIL = '{{SEAFILE_EMAIL}}'
