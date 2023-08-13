---
title: "symbian-gzip解压缩"
date: 2013-04-11
lastmod: 2013-04-11
categories:
  - "其它"
tags:
  - "其它"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

#### gbk数据解压缩转成Unicode编码数据

```objective-c
const TBool GBKCompressToUnicodeL(const TDesC8& aGBKData,RBuf& aUnicodeData)
{
	z_stream stream;   
	memset(&stream, 0, sizeof(z_stream));   

	const uInt inputBufLen = aGBKData.Length() + 1;

	stream.avail_in = inputBufLen;
	stream.next_in = (Bytef*)aGBKData.Ptr(); 

	TInt res = inflateInit(&stream);

	TBool isUncompressOK = EFalse ;

	RBuf8 gbkUncompressData;
	CleanupClosePushL(gbkUncompressData);
	gbkUncompressData.Create((inputBufLen<<3));
	gbkUncompressData.Zero();
	
	if ( res == Z_OK)
	{
		TInt pakLen = 256;
		Bytef* pakBuf = NULL;
		
		if ( inputBufLen > 120 * 1024 )
		{
			pakLen = 4096;
		}
		else if ( inputBufLen > 80 * 1024 )
		{
			pakLen = 2048;
		}
		else if ( inputBufLen > 50 * 1024 )
		{
			pakLen = 1024;
		}
		else if ( inputBufLen > 20 * 1024 )
		{
			pakLen = 512;
		}
		
		pakBuf = new (ELeave)Bytef[pakLen];

		TInt memAllocRes = KErrNone;
		
		while(stream.avail_out == 0)
		{
			memset(pakBuf,0,pakLen * sizeof(Bytef));

			stream.avail_out = pakLen;
			stream.next_out = pakBuf; 

			res = inflate(&stream, Z_NO_FLUSH);
			
			switch (res)
			{
			case Z_NEED_DICT:
			case Z_DATA_ERROR:
			case Z_MEM_ERROR:
			case Z_STREAM_ERROR:
			case Z_BUF_ERROR:
			{
				isUncompressOK = EFalse;
				break;
			}

			default:
			{
				if ( res == Z_OK ||  res == Z_STREAM_END)
				{
					const TInt  dataLen = pakLen - stream.avail_out;
					
					const TInt curBufLen = gbkUncompressData.Length();
					const TInt maxBufLen = gbkUncompressData.MaxLength();

					if ( curBufLen + dataLen > maxBufLen)
					{
						memAllocRes = gbkUncompressData.ReAlloc(curBufLen + dataLen + (pakLen<<3));
					}

					if ( KErrNone == memAllocRes )
					{
						gbkUncompressData.Append((const TUint8*)pakBuf,dataLen);
						isUncompressOK = ETrue;
					}
				}

				break;
			}

			}
			
			if ( KErrNone != memAllocRes )
			{
				isUncompressOK = EFalse;
				break;
			}
		}
		
		
		delete[] pakBuf;
		pakBuf = NULL;
	}

	const TInt len = stream.total_out;

	inflateEnd(&stream);

	aUnicodeData.Close();

	if ( isUncompressOK )
	{
		RFs& fs = CEikonEnv::Static()->FsSession();

		const TInt allocRes = aUnicodeData.Create(gbkUncompressData.Length() * 3);	
		
		if ( KErrNone == allocRes)
		{
			CCnvCharacterSetConverter* gbkToUnicodeLE = CCnvCharacterSetConverter::NewLC();
			gbkToUnicodeLE->PrepareToConvertToOrFromL(KCharacterSetIdentifierGbk, fs);

			TInt state = CCnvCharacterSetConverter::KStateDefault;
			const TInt convertRes = gbkToUnicodeLE->ConvertToUnicode(aUnicodeData, gbkUncompressData, state);

			if(KErrNone != convertRes)
			{
				isUncompressOK = EFalse;
			}

			/**release**/
			CleanupStack::PopAndDestroy(gbkToUnicodeLE);
		}
		else
		{
			isUncompressOK = EFalse;
		}
			
	}

	CleanupStack::PopAndDestroy(&gbkUncompressData);

	return isUncompressOK;
}

```

