from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.conf import settings


class Command(BaseCommand):
    help = 'Create admin user from settings.ADMIN_LOGIN, ADMIN_PASS, ADMIN_EMAIL (set via environment)'

    def handle(self, *args, **kwargs):
        User = get_user_model()
        username = settings.ADMIN_LOGIN
        password = settings.ADMIN_PASS
        email = settings.ADMIN_EMAIL

        if not username or not password:
            self.stdout.write(self.style.WARNING('ADMIN_LOGIN or ADMIN_PASS not set, skipping admin creation.'))
            return

        if User.objects.filter(username=username).exists():
            self.stdout.write(self.style.WARNING(f'Admin user "{username}" already exists, skipping creation.'))
            return

        User.objects.create_superuser(username=username, password=password, email=email)
        self.stdout.write(self.style.SUCCESS(f'Admin user "{username}" created successfully.')) 