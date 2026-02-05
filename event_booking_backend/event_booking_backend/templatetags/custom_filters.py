from django import template

register = template.Library()


@register.filter(name="length_is")
def length_is(value, arg):
    """Return True if len(value) == arg.

    Mirrors the removed Django template filter used by Jazzmin templates.
    """
    try:
        return len(value) == int(arg)
    except (TypeError, ValueError):
        return False
