# -*- coding: utf-8 -*-
# Generated by Django 1.11.6 on 2017-12-01 04:48
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('post', '0007_auto_20171201_1123'),
    ]

    operations = [
        migrations.AddField(
            model_name='photos',
            name='test',
            field=models.CharField(default=1, max_length=10),
            preserve_default=False,
        ),
    ]
