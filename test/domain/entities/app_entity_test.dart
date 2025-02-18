import 'package:flutter_test/flutter_test.dart';
import 'package:roost_mvp/domain/entities/app_entity.dart';

void main() {
  test("should correctly initialize AppEntity", () {
    final app =
        AppEntity(id: "1", name: "Test App", platform: "iOS", version: "1.0.0");

    expect(app.id, "1");
    expect(app.name, "Test App");
    expect(app.platform, "iOS");
    expect(app.version, "1.0.0");
  });
}
