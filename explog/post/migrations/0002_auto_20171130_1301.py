# -*- coding: utf-8 -*-
# Generated by Django 1.11.6 on 2017-11-30 04:01
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('post', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='postphoto',
            name='subpost',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, to='post.SubPost'),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='postphoto',
            name='post',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='post.Post'),
        ),
    ]
