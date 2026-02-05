from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver

from events.models import Event

try:
    from src.rag.ingest import upsert_event
    from src.lib.upstash import index
except Exception:  # pragma: no cover
    upsert_event = None
    index = None


def _event_to_row(event: Event) -> dict:
    return {
        "id": event.id,
        "title": event.title,
        "description": event.description,
        "location_name": event.location_name,
        "time": str(event.time) if event.time else None,
        "image": event.image.name if event.image else None,
        "date": str(event.date) if event.date else None,
        "latitude": event.latitude,
        "longitude": event.longitude,
    }


@receiver(post_save, sender=Event)
def ingest_event_on_save(sender, instance: Event, **kwargs):
    if upsert_event is None:
        return
    row = _event_to_row(instance)
    upsert_event([row])


@receiver(post_delete, sender=Event)
def ingest_event_on_delete(sender, instance: Event, **kwargs):
    if index is None:
        return
    try:
        index.delete(str(instance.id))
    except Exception:
        pass
