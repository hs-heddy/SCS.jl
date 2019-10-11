using BinaryProvider, Libdl # requires BinaryProvider 0.3.0 or later

## NOTE: This is not a typical build.jl file; it has extra stuff toward the bottom.
## Don't just replace this file with the output of a BinaryBuilder repository!

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libscsindir"], :indirect),
    LibraryProduct(prefix, ["libscsdir"], :direct),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaOpt/SCSBuilder/releases/download/v2.1.1"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/SCSBuilder.v2.1.1.aarch64-linux-gnu-gcc4.tar.gz", "6a9ec21545b37ad26d86ea5385303290ea19766f4bd3d50a8d5076c2c792b0be"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/SCSBuilder.v2.1.1.aarch64-linux-gnu-gcc7.tar.gz", "e6be73a296da8df03c81204172d6df9ed9be13e84f0f89ba47138e2631616b3d"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/SCSBuilder.v2.1.1.aarch64-linux-gnu-gcc8.tar.gz", "29514a4f263ebdc3830a4d9fa6bb75c682b97032f866cec9859e3b697bd3d5ae"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/SCSBuilder.v2.1.1.aarch64-linux-musl-gcc4.tar.gz", "3f1e905042d3a752fad02d7feeb9dfc0aa4972bff754ddd9f882ea6f4066d3a6"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/SCSBuilder.v2.1.1.aarch64-linux-musl-gcc7.tar.gz", "dc0bd19bb4eaa711d306c895ff331d9b4904329cb187d3f925400ce291c5f820"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/SCSBuilder.v2.1.1.aarch64-linux-musl-gcc8.tar.gz", "166bcc7afd34364eef034cd2177b8328e3de5e185608e3b75e1040afdbd0ad2b"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/SCSBuilder.v2.1.1.arm-linux-gnueabihf-gcc4.tar.gz", "80b2f66b000b7156a5e86f9520faf0527f8d34b3d6f5027e4db895f4e31a737a"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/SCSBuilder.v2.1.1.arm-linux-gnueabihf-gcc7.tar.gz", "15869bc58cedeae9968372dbcb3c023c3abd9d9c88eecb3d34f53e640575cee3"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/SCSBuilder.v2.1.1.arm-linux-gnueabihf-gcc8.tar.gz", "5c684b9d75f872822c7e70fd48e72f6893ed4ce2241ef6da9f194d503cb71cb6"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/SCSBuilder.v2.1.1.arm-linux-musleabihf-gcc4.tar.gz", "1d5b57ec214d111b9fa238bd2e99bdb2e012ece767700dd5c9474bdf3b937cca"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/SCSBuilder.v2.1.1.arm-linux-musleabihf-gcc7.tar.gz", "1e70894cd904ad6db23fe6f18b413b7c3b2b73368d979c67fde8998027960289"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/SCSBuilder.v2.1.1.arm-linux-musleabihf-gcc8.tar.gz", "222c04aac1066368f5cf6af276d0c2636740a07db41acd1fe509616f45ae9016"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/SCSBuilder.v2.1.1.i686-linux-gnu-gcc4.tar.gz", "b368e4197f27f9b515b3dc7246506bcd05540238831ebaa4ae1fecaa52e7a4f7"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/SCSBuilder.v2.1.1.i686-linux-gnu-gcc7.tar.gz", "4ae2bd74a76dc187c3d73a7b6c1be250b4e3d59dabac3325c047f37dd780361a"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/SCSBuilder.v2.1.1.i686-linux-gnu-gcc8.tar.gz", "6a70041e6405dba52fd0e7049b288fbf51a9df290982a989cb1b9de83f15ed64"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/SCSBuilder.v2.1.1.i686-linux-musl-gcc4.tar.gz", "d5e1ead5f165dcd8a0f04c30e0a0c7b2e461dca9a4713d3c174779d07264ce10"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/SCSBuilder.v2.1.1.i686-linux-musl-gcc7.tar.gz", "eadee1ae94fc4969e09edce7aace4094705252860107ad1555e29d7bde5e7b4e"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/SCSBuilder.v2.1.1.i686-linux-musl-gcc8.tar.gz", "544c0f8c3ec1108503e8e83e9895dd6ed6d3921f808bd20cf13efcab89ed69c5"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/SCSBuilder.v2.1.1.i686-w64-mingw32-gcc4.tar.gz", "1c829010d86ca8e8b59c9a4745daed5590e53c4d3bc2c9b07c7889167098bdae"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/SCSBuilder.v2.1.1.i686-w64-mingw32-gcc7.tar.gz", "bee88bf32d68360e8903de363e41f9397de54cab9548ea34b5308f09305fa2cc"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/SCSBuilder.v2.1.1.i686-w64-mingw32-gcc8.tar.gz", "88aac64cc41ff1075dec145ac90f875e97874f1755013cac19212daa4afb43dc"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/SCSBuilder.v2.1.1.powerpc64le-linux-gnu-gcc4.tar.gz", "3362f33e595094d7b96067faaea2a5daa864a2a9de11c91cd8e6be5a3f7edb93"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/SCSBuilder.v2.1.1.powerpc64le-linux-gnu-gcc7.tar.gz", "a7a937ae8eb9b3a7434c612d531dee820f5f7eb320b2c097d2442ebf4cd6b0b3"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/SCSBuilder.v2.1.1.powerpc64le-linux-gnu-gcc8.tar.gz", "82194e4970a855eae9e21a4d8db8aa061f8085db00d24114ca8fbed83f23abbe"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-apple-darwin14-gcc4.tar.gz", "70ffc20ec600d34847c4d7fd6c7e208a8878387942ccc66496e6f0777e4038a0"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-apple-darwin14-gcc7.tar.gz", "c2dedd06d3fa2c7c9163e4f050d6b98a6b502d01c7c4ea1eefb74063209056a9"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-apple-darwin14-gcc8.tar.gz", "e5aa4fd6931ad70d598778aaabf4e59896aef336e3afa33f9af9e070037d6ac2"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-linux-gnu-gcc4.tar.gz", "a68578bff9cf841bc3e9513b3ded1b16cdaf4b4ce1e6c6bb81d4638288a7e961"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-linux-gnu-gcc7.tar.gz", "dc5cd263df443610e1494e7a315c3cd4eab79dc032a737efee9649cc3c78cc71"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-linux-gnu-gcc8.tar.gz", "3e5fbba79ca7dc433e46dbb225d3ceb82affb808e44063f75ccaccb6793243f8"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-linux-musl-gcc4.tar.gz", "42adf6ad6cd6cb7b562b029b9a52a2180603fce59201942a6c2921d13163fd1a"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-linux-musl-gcc7.tar.gz", "ce0c61d46460e4660feba989d32c701273d83720e94644bcc36da0ec3fe062cc"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-linux-musl-gcc8.tar.gz", "3fb78281cf338c2ba5d00e7e4725332542b6cf90bc94e22426e17c40b7f9fd2a"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-unknown-freebsd11.1-gcc4.tar.gz", "63e77de3f4b5815c6a24b366dc543f1877431a2dffd703abd31554881bb37fe9"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-unknown-freebsd11.1-gcc7.tar.gz", "f10748aedb94e73358034d8f7e9ab5d91e98da904d8e188e80071c0143906e3e"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-unknown-freebsd11.1-gcc8.tar.gz", "6b893a7ca6f255cea16078f1dd9922806f4dc955ad5a7295591e1a9c36d38553"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-w64-mingw32-gcc4.tar.gz", "38614a19c9172c62c2a3c5741929cc07e37953e68eaa4b5d21a3a27916587c2d"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-w64-mingw32-gcc7.tar.gz", "eeebd4d874009d58caee8db866a85ba7e2e75ede03dea391ce694e9545415da9"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/SCSBuilder.v2.1.1.x86_64-w64-mingw32-gcc8.tar.gz", "6ed97aa25749e0047b2bcd61ab37399c372cc8fb1d2ac8cb30c1790ff6e3c144"),
)

this_platform = platform_key_abi()

custom_library = false
if haskey(ENV,"JULIA_SCS_LIBRARY_PATH")
    custom_products = [LibraryProduct(ENV["JULIA_SCS_LIBRARY_PATH"],product.libnames,product.variable_name) for product in products]
    if all(satisfied(p; verbose=verbose) for p in custom_products)
        products = custom_products
        custom_library = true
    else
        error("Could not install custom libraries from $(ENV["JULIA_SCS_LIBRARY_PATH"]).\nTo fall back to BinaryProvider call delete!(ENV,\"JULIA_SCS_LIBRARY_PATH\") and run build again.")
    end
end

if !custom_library
    # Install unsatisfied or updated dependencies:
    unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)

    dl_info = choose_download(download_info, this_platform)
    if dl_info === nothing && unsatisfied
        # If we don't have a compatible .tar.gz to download, complain.
        # Alternatively, you could attempt to install from a separate provider,
        # build from source or something even more ambitious here.
        error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
    end

    # If we have a download, and we are unsatisfied (or the version we're
    # trying to install is not itself installed) then load it up!
    if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
        # Download and install binaries
        install(dl_info...; prefix=prefix, force=true, verbose=verbose)
    end
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
