bool bit2Bool(Map<String, dynamic> json, String field) {
  return (json[field] != null) ? json[field] == 1 : false;
}

class BaseModel {}
