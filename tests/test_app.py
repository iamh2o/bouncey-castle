import sys, os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))
import app

def test_homepage(client):
    resp = client.get('/')
    assert resp.status_code == 200
    assert b'Bouncey Castle' in resp.data

def test_bounce_example(client):
    resp = client.get('/?bounce_url=https://example.com')
    assert resp.status_code == 200


def test_debug(client):
    resp = client.get('/?bounce_url=https://example.com&debug=1')
    assert b'Debug info' in resp.data

import pytest

@pytest.fixture
def client():
    with app.app.test_client() as client:
        yield client
