from rest_framework.pagination import PageNumberPagination


class PushListPagination(PageNumberPagination):
    page_size = 6
