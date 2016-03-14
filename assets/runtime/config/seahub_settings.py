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
