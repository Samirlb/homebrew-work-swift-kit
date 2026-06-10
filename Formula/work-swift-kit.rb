class WorkSwiftKit < Formula
  desc "Interactive dev environment setup for multi-account workflows (git, SSH, zsh, Claude Code, AI tools)"
  homepage "https://github.com/Samirlb/Work-Swift-Kit"
  url "https://github.com/Samirlb/Work-Swift-Kit/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "bca7cbd8d94f4c23f6764e8491e6f6ae92f589a4e063af3097f41a55f9853ecf"
  license "MIT"

  depends_on "gum"
  depends_on "stow"
  depends_on "fzf"
  depends_on "gettext"
  depends_on "jq"
  depends_on "sd"
  depends_on :macos

  def install
    prefix.install Dir["*"]
    (bin/"wsk").write <<~EOS
      #!/usr/bin/env bash
      WSK_DIR="#{prefix}"
      export WSK_DIR
      case "${1:-}" in
        ""|menu)                                exec bash "$WSK_DIR/install.sh" ;;
        setup|accounts|terminals|relink|doctor|check|update|ai|sync)
                                                exec bash "$WSK_DIR/install.sh" "$1" ;;
        install)                               exec bash "$WSK_DIR/install.sh" setup ;;
        -v|--version|version)                  exec bash "$WSK_DIR/install.sh" version ;;
        -h|--help|help)
          echo "Usage: wsk [command]"
          echo
          echo "  (no command)  Open the interactive menu"
          echo "  setup         Full setup: accounts, packages, terminals, AI dev tools, dotfiles"
          echo "  accounts      Configure accounts only"
          echo "  terminals     Install terminals/editors only"
          echo "  ai            Install Claude Code, AI framework, codegraph and skills per account"
          echo "  sync          Sync gentle-ai configs and skills for all accounts"
          echo "  doctor        Check configuration (read-only health check)"
          echo "  update        Update the kit and upgrade packages"
          echo "  relink        Re-symlink dotfiles without re-collecting accounts"
          echo "  version       Print the current wsk version"
          ;;
        *)
          echo "Unknown command: $1" >&2
          echo "Run 'wsk --help' for usage." >&2
          exit 1
          ;;
      esac
    EOS
    chmod 0755, bin/"wsk"
  end

  def caveats
    <<~EOS
      To open the interactive menu:
        wsk

      Direct commands:
        wsk setup      # full setup (accounts, packages, terminals, AI dev tools, dotfiles)
        wsk ai         # install Claude Code, AI framework, codegraph and skills per account
        wsk sync       # sync gentle-ai configs and skills for all accounts
        wsk doctor     # check configuration
        wsk update     # update kit and tools
        wsk relink     # re-link dotfiles
        wsk version    # print current version
    EOS
  end

  test do
    assert_predicate prefix/"install.sh", :exist?
  end
end
