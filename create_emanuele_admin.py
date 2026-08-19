import sys
pin = sys.stdin.readline().strip()
if not pin:
    print("ERROR: No PIN provided on stdin", file=sys.stderr); sys.exit(1)
from chatbot.admin.auth import create_admin_user
try:
    user = create_admin_user("emanuele", pin, permission_level=2)
    print(f"SUCCESS: created user {user['username']} (id={user['id']}, level={user['permission_level']})")
except ValueError as e:
    print(f"ERROR: {e}")
