// 1) base
import "base/config_list_test.dart" as base_config_list_test;

// 2) ilist
import "ilist/ilist_test.dart" as ilist_test;

// 3) iset
import "iset/iset_test.dart" as iset_test;

// 4) imap
import "imap/imap_test.dart" as imap_test;

void main() {
  // 1) base
  base_config_list_test.main();

  // 2) ilist
  ilist_test.main();

  // 3) iset
  iset_test.main();

  // 4) imap
  imap_test.main();
}
