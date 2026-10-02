package = {
    spec = "2",

    name = "oh-my-pi",
    description = "Coding agent with the IDE wired in",
    homepage = "https://omp.sh",
    repo = "https://github.com/can1357/oh-my-pi",
    docs = "https://github.com/can1357/oh-my-pi#readme",
    licenses = {"MIT"},
    -- Add each new upstream stable release by reviewed PR; keep older pins.

    -- The glibc release executable uses the host loader and libc (GLIBC_2.17);
    -- it has no bundled shared libraries or xim-provided runtime closure.
    -- Do not add xim:glibc: that would make elfpatch rewrite this Bun binary.
    -- The xvm-launched OMP disables startup update checks; an explicit
    -- `omp update` is still user-controlled and is not intercepted here.

    type = "package",
    archs = {"x86_64", "aarch64"},
    status = "stable",
    categories = {"ai", "cli", "tools"},
    keywords = {"oh-my-pi", "omp", "coding-agent"},

    programs = {"omp"},
    xvm_enable = true,

    xpm = {
        linux = {
            source = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/omp-linux-${arch_alias}",
            ["latest"] = { ref = "18.4.10" },
            ["18.4.10"] = {
                arch_alias = { x86_64 = "x64", aarch64 = "arm64" },
                sha256 = {
                    x86_64 = "e3f24c475d90b83acec05a26fd4499d2e6dffbf4ca3b0ee9e3e1bc1ab1a4e289",
                    aarch64 = "8f6b0b6547b149b7f538d44848e80502f5895663ca9cef6b14c7337be2f4f617",
                },
            },
        },
        macosx = {
            source = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/omp-darwin-${arch_alias}",
            ["latest"] = { ref = "18.4.10" },
            ["18.4.10"] = {
                arch_alias = { x86_64 = "x64", aarch64 = "arm64" },
                sha256 = {
                    x86_64 = "88cb5bc7fc8a32a16276be3af3a7e9e9f195a4c994db75f15ee0bc24dd30928d",
                    aarch64 = "23d3f9ab712fe700e80a43dbd1e8159dfea8e106bf717648a49b1bba1ad3e508",
                },
            },
        },
        windows = {
            source = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/omp-windows-${arch_alias}.exe",
            ["latest"] = { ref = "18.4.10" },
            ["18.4.10"] = {
                arch_alias = { x86_64 = "x64", aarch64 = "arm64" },
                sha256 = {
                    x86_64 = "7232c209641f0cad7e20bdb3a074cdb2fb31ae2aa73d42c491c705d28e0d3895",
                    aarch64 = "21eba9799ba0310b94cc1937c092f3ad376c6608a9f5a30340b10ec8e7ecd817",
                },
            },
        },
    },
}

import("xim.libxpkg.pkginfo")
import("xim.libxpkg.xvm")
import("xim.libxpkg.system")

function install()
    os.tryrm(pkginfo.install_dir())
    os.mkdir(pkginfo.install_dir())

    local source = pkginfo.install_file()
    local target = path.join(pkginfo.install_dir(), is_host("windows") and "omp.exe" or "omp")
    os.mv(source, target)

    local config = path.join(pkginfo.install_dir(), "xlings-config.yml")
    io.writefile(config, "startup:\n  checkUpdate: false\n")

    if not is_host("windows") then
        system.exec(string.format([[chmod +x "%s"]], target))
    end

    return os.isfile(target) and io.readfile(config) == "startup:\n  checkUpdate: false\n"
end

function config()
    local alias = is_host("windows") and "omp.exe" or "omp"
    xvm.add(package.name, { type = "group" })
    xvm.add("omp", {
        bindir = pkginfo.install_dir(), alias = alias,
        envs = { PI_CONFIG_FILES = path.join(pkginfo.install_dir(), "xlings-config.yml") },
    })
    return true
end

function uninstall()
    xvm.remove("omp")
    xvm.remove(package.name)
    return true
end
