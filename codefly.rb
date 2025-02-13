# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Codefly < Formula
  desc "codefly CLI"
  homepage "https://codefly.ai"
  version "0.0.126"
  depends_on :macos

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/codefly-dev/cli-releases/releases/download/v0.0.126/codefly-darwin-arm64"
    end
    if Hardware::CPU.intel?
      url  "https://github.com/codefly-dev/cli-releases/releases/download/v0.0.126/codefly-darwin-amd64"
    end

    def install
      binary_name = Hardware::CPU.intel? ? "codefly-darwin-amd64" : "codefly-darwin-arm64"
      bin.install binary_name => "codefly"
    end

    def post_install
      # Generate and install completion scripts
      system "#{bin}/codefly completion bash > #{bash_completion}/codefly" if build.with? "completion"
      system "#{bin}/codefly completion zsh > #{zsh_completion}/_codefly" if build.with? "completion"
      system "#{bin}/codefly completion fish > #{fish_completion}/codefly.fish" if build.with? "completion"
    end

    def caveats
      <<~EOS
    EOS
    end
  end
end
