from django.conf import settings
from django.db.models.fields.files import ImageFieldFile, ImageField

__all__ = (
    'DefaultStaticImageField',
    'DefaultStaticPostImageField',
)


class DefaultStaticImageFieldFile(ImageFieldFile):
    @property
    def url(self):
        try:
            return super().url
        except ValueError:
            from django.contrib.staticfiles.storage import staticfiles_storage
            return staticfiles_storage.url(self.field.static_image_path)


class DefaultStaticImageField(ImageField):
    attr_class = DefaultStaticImageFieldFile

    def __init__(self, *args, **kwargs):
        self.static_image_path = kwargs.pop(
            'default_image_path',
            getattr(settings, 'DEFAULT_IMAGE_PATH', 'default.jpg'))
        super().__init__(*args, **kwargs)


class DefaultStaticPostImageField(ImageField):
    attr_class = DefaultStaticImageFieldFile

    def __init__(self, *args, **kwargs):
        self.static_image_path = kwargs.pop(
            'default_image_path',
            getattr(settings, 'DEFAULT_IMAGE_POST_PATH', 'default_post.jpg'))
        super().__init__(*args, **kwargs)


