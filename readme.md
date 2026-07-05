# 信息论笔记：不那么适合速记的速记纸

使用方法
1. 克隆仓库
2. 在vscode中打开仓库，并安装扩展 "Tinymist Typst"
3. 安装如下字体
    + IBM Plex Serif
    + IBM Plex Mono
    + Source Han Serif SC
    + Source Han Sans SC
4. 打开“main.typ”，点击右上方“Typst预览”以预览，点击“显示导出的PDF”以编译

如果不想安装字体, 可以直接克隆字体仓库再编译, 在根目录执行如下命令:
```bash
git clone https://github.com/guanfuqi/fonts.git fonts --depth=1
typst compile main.typ 信息论笔记.pdf --font-path fonts
```