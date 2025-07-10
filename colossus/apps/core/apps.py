from django.apps import AppConfig
from django.db.models.signals import post_migrate
import os

def fix_site_domain(sender, **kwargs):
    # Импортируем только внутри функции!
    from django.contrib.sites.models import Site
    from django.conf import settings
    site = Site.objects.get(pk=getattr(settings, 'SITE_ID', 1))
    if site.domain == 'example.com':
        host = os.environ.get('COLOSSUS_SITE_DOMAIN', 'localhost:8000')
        site.domain = host
        site.name = 'Colossus'
        site.save()


class CoreConfig(AppConfig):
    name = 'colossus.apps.core'

    def ready(self):
        post_migrate.connect(fix_site_domain, sender=self)
