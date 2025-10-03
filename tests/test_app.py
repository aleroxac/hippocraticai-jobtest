import os, sys
import pytest

from app import app

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_health(client):
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.get_json() == {"status": "UP"}

def test_hello(client):
    resp = client.get("/hello")
    assert resp.status_code == 200
    assert resp.get_json() == {"message": "Hello Augusto!"}
