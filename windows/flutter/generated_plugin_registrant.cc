//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <custom_text_form_field_plus/custom_text_form_field_plus_plugin_c_api.h>
#include <file_selector_windows/file_selector_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  CustomTextFormFieldPlusPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("CustomTextFormFieldPlusPluginCApi"));
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
}
