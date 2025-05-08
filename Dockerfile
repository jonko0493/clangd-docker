FROM ubuntu AS build

RUN apt update && \
    apt install -y cmake gcc g++ git gnupg lsb-release software-properties-common wget

RUN git clone --depth 1 https://github.com/llvm/llvm-project.git && \
    cd llvm-project && \
    cmake -S llvm -B build -G Ninja -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" -DCMAKE_INSTALL_PREFIX="/work/clangd" -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build --target clangd

FROM ubuntu

COPY --from=build --link "/llvm-project/build/bin" "/clangd/bin"
COPY --from=build --link "/llvm-project/build/lib" "/clangd/lib"

ENTRYPOINT [ "/bin/bash" ]