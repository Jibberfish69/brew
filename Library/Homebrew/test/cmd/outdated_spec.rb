# frozen_string_literal: true

require "cmd/outdated"
require "cmd/shared_examples/args_parse"

RSpec.describe Homebrew::Cmd::Outdated do
  it_behaves_like "parseable arguments"

  it "outputs JSON", :integration_test do
    setup_test_formula "testball"
    (HOMEBREW_CELLAR/"testball/0.0.1/foo").mkpath

    expected_json = JSON.pretty_generate({
      formulae: [{
        name:               "testball",
        installed_versions: ["0.0.1"],
        current_version:    "0.1",
        pinned:             false,
        pinned_version:     nil,
      }],
      casks:    [],
    })
    # json v2.8.1 is inconsistent it how it renders empty arrays,
    # for now we allow multiple outputs:
    alternate_json = expected_json.gsub("[]", "[\n\n]")

    expect { brew "outdated", "--json=v2" }
      .to output(eq("#{expected_json}\n").or(eq("#{alternate_json}\n"))).to_stdout
      .and be_a_success
  end
end
