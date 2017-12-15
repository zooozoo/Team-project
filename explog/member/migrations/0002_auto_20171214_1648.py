# -*- coding: utf-8 -*-
# Generated by Django 1.11.6 on 2017-12-14 07:48
from __future__ import unicode_literals

from django.db import migrations
import utils.custom_image_filed


class Migration(migrations.Migration):

    dependencies = [
        ('member', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='img_profile',
            field=utils.custom_image_filed.DefaultStaticImageField(blank=True, default='static/default.jpg', upload_to='user'),
            preserve_default=False,
        ),
    ]