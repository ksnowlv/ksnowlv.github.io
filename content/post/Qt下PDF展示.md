---
title: "Qt下PDF展示"
date: 2024-01-01T21:52:22+08:00
lastmod: 2024-01-01T21:52:22+08:00
keywords: ["Qt", "PDF"]
tags: ["Qt", "PDF"]
categories: ["Qt", "PDF"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Qt下PDF展示

Qt下PDF展示有多种方案，可以使用第三方PDF开源组件，本文计划采用Qt自带的DPF组件。


### 1.Qt PDF组件

![image](/images/post/Qt下PDF展示/Qt_PDF.png)

确保PDF组件安装了，如果没有安装，重新安装该PDF组件。

### 2.CMakelists.txt添加DPF支持

```CMakeLists
# 添加Pdf PdfWidgets库
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Widgets Pdf PdfWidgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Widgets Pdf PdfWidgets)

# 目前文件链接到Pdf PdfWidgets库
target_link_libraries(PDFTest PRIVATE Qt${QT_VERSION_MAJOR}::Pdf)
target_link_libraries(PDFTest PRIVATE Qt${QT_VERSION_MAJOR}::PdfWidgets)

```

### 3.PDF相关代码

MainWindow.h代码如下

```c++

class QTimer;
class QPdfPageSelector;
class QPdfView;
class QPdfDocument;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void handleShowPdfEvent();
    void handleSavePdfEvent();

private:
    void initPDF();
    void pageSelected(int page);

private:
    Ui::MainWindow *ui;
    
    QList<QPixmap> imageList;
    
    QPdfPageSelector *m_pageSelector;
    QPdfView *m_pdfView;
    QPdfDocument* m_pdfDocument;
};
#endif // MAINWINDOW_H


```

MainWindow.cpp代码如下

```c++
#include <QPdfDocument>
#include <QThread>
#include <QTimer>
#include <QListWidgetItem>
#include <QListWidget>
#include <QFileDialog>
#include <QtPdfWidgets>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    initPDF();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::handleShowPdfEvent() {
    QString filePath = ":/resource/k8s 实战案例.pdf";
    QPdfDocument pdfDoc(this);
    const QPdfDocument::Error& error = pdfDoc.load(filePath);

    if (error != QPdfDocument::Error::None) {
        qDebug()<<"pdf open error";
        return;
    }

    imageList.clear();

    for (int page = 0; page < pdfDoc.pageCount(); page++)
    {
        QSizeF size = pdfDoc.pagePointSize(page);
        QImage image = pdfDoc.render(page, QSize(size.width(), size.height()));
        QPixmap pixmap = QPixmap::fromImage(image);
        imageList.append(pixmap);
    }
    
    pdfDoc.close();
    
    QListWidget* listWidget = ui->listWidget;

    // 添加图片文件名和图像到列表中
    for (const QPixmap& pixmap : imageList) {
        // 添加图片文件名
        QListWidgetItem *item = new QListWidgetItem(listWidget, 0);
        item->setIcon(QIcon(pixmap.scaled(listWidget->size(), Qt::KeepAspectRatio, Qt::SmoothTransformation)));

        item->setTextAlignment(Qt::AlignHCenter); // 设置文本居中显示
        listWidget->addItem(item);
    }

    listWidget->setIconSize(listWidget->size());
}

void MainWindow::handleSavePdfEvent() {

    // 获取目标目录
    QString saveDir = QFileDialog::getExistingDirectory(nullptr, "选择保存目录", QDir::homePath());

    int countImage = 0;
    for(const QPixmap& pixmap : imageList) {
        QString fileName = saveDir+ QString("/page_%1.png").arg(countImage);
        bool ok = pixmap.save(fileName);
        qDebug()<<fileName<< ",ok:"<<ok;
        ++countImage;
    }
}

void MainWindow::initPDF() {
    // 创建 QPdfPageSelector 控件
    m_pageSelector = new QPdfPageSelector(this);
    m_pageSelector->setGeometry(310,0,30,600);

    // 创建 QPdfView 控件
    m_pdfView = new QPdfView(this);
    m_pdfView->setGeometry(0,0, 300, 600);

    QString filePath = ":/resource/k8s 实战案例.pdf";
    m_pdfDocument = new QPdfDocument(this);
    const QPdfDocument::Error& error = m_pdfDocument->load(filePath);

    m_pdfView->setDocument(m_pdfDocument);
    m_pdfView->setPageMode(QPdfView::PageMode::MultiPage);

    m_pageSelector->setDocument(m_pdfDocument);
    connect(m_pageSelector, &QPdfPageSelector::currentPageChanged, this, &MainWindow::pageSelected);
    m_pageSelector->setMaximumWidth(150);
}

void MainWindow::pageSelected(int page)
{
    auto pageNavigator = m_pdfView->pageNavigator();
    pageNavigator->jump(page, {}, pageNavigator->currentZoom());
    const auto documentTitle = m_pdfDocument->metaData(QPdfDocument::MetaDataField::Title).toString();
    setWindowTitle(!documentTitle.isEmpty() ? documentTitle : QStringLiteral("PDF Viewer"));
    setWindowTitle(tr("%1: page %2 (%3 of %4)")
                       .arg(documentTitle.isEmpty() ? u"PDF Viewer"_qs : documentTitle,
                            m_pageSelector->currentPageLabel(), QString::number(page + 1), QString::number(m_pdfDocument->pageCount())));
}

```

### 4.显示效果

![image](/images/post/Qt下PDF展示/pdf_overview.png)

除了使用pdf库直接展示pdf，还可以通过QPdfDocument把pdf文档转换成图片，在QListWidget列表中展示图片，也可以试下这种解决思路看看效果。


