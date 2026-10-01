package = {
    spec = "2",

    name = "oh-my-pi",
    description = "Coding agent with the IDE wired in",
    homepage = "https://omp.sh",
    repo = "https://github.com/can1357/oh-my-pi",
    docs = "https://github.com/can1357/oh-my-pi#readme",

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
            ["latest"] = { ref = "18.4.9" },
            ["18.4.9"] = {
                arch_alias = { x86_64 = "x64", aarch64 = "arm64" },
                sha256 = {
                    x86_64 = "fe1ec455e3aa4536efc8e28b1023113de94b97e7dd68c726964dadeb488a1753",
                    aarch64 = "c86ac994dd9a99b1f8df28b85c9ccc909c81f64c68f9e30039ee980a05308438",
                },
            },
        },
        macosx = {
            source = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/omp-darwin-${arch_alias}",
            ["latest"] = { ref = "18.4.9" },
            ["18.4.9"] = {
                arch_alias = { x86_64 = "x64", aarch64 = "arm64" },
                sha256 = {
                    x86_64 = "ac5b866d8e6f380836cc77c92253d6596e4b67932a95d02bd55a3ebc8c5c3845",
                    aarch64 = "88c8ff6734bd62b9fe65004f265218eed8e5b8695e64da1172587f5aeb468681",
                },
            },
        },
        windows = {
            source = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/omp-windows-${arch_alias}.exe",
            ["latest"] = { ref = "18.4.9" },
            ["18.4.9"] = {
                arch_alias = { x86_64 = "x64", aarch64 = "arm64" },
                sha256 = {
                    x86_64 = "991348ba6dfec66a907cc42f8dec868029db906ba40910a566f63f659bdeede5",
                    aarch64 = "35f5a68e0685fe50683ccab49f8e600af1eaeade390c323d14b1079afa2f18eb",
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

    if not is_host("windows") then
        system.exec(string.format([[chmod +x "%s"]], target))
    end

    return true
end

function config()
    local alias = is_host("windows") and "omp.exe" or "omp"
    xvm.add("omp", { bindir = pkginfo.install_dir(), alias = alias })
    return true
end

function uninstall()
    xvm.remove("omp")
    return true
end
