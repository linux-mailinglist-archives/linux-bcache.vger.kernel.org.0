Return-Path: <linux-bcache+bounces-1264-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23999C7F656
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Nov 2025 09:34:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD3873A5BFB
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Nov 2025 08:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062902989B4;
	Mon, 24 Nov 2025 08:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="ymBZM06H"
X-Original-To: linux-bcache@vger.kernel.org
Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8E525BEE8
	for <linux-bcache@vger.kernel.org>; Mon, 24 Nov 2025 08:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763973285; cv=none; b=NCxm9qM6m6fZc+XZ9C7e0E946PGmuyliqVWsLfIRlTY3lwnFaO7rEEkkyAs0KbDmf9GTAnhMkXcUeWmBWmN2sopZy4CNq2/qYUt0nj1ddwBRuqkL3c5INmKtatrrX+LNzBu7JrjiVTw6fyG39pMlg14Dgl5SpyFxJ3ndpVAKAXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763973285; c=relaxed/simple;
	bh=cLynWp3+xRbU3X10UJgdhCMNeGKdopMbWlcvgCv0kK8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=PdGXb1pBUq+IYzmZLv/UxuQaRiSDvYuT09cdO77ZDdFyjpiFu9/vue1d9WQyGE4FcaJBAStTTTGsIT/BzcxFUSpn7mv7fytmMzXCk3Ec55MWZX0JtvK0F3thBt47t4seUsEtnArwcDM1Z58bd98py0j9J5PaBdoSsCFMBK5reWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=ymBZM06H; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id NM5NvVy07SkcfNS1tvbKRa; Mon, 24 Nov 2025 08:34:37 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id NS1svo4IQOs9RNS1tv2NVS; Mon, 24 Nov 2025 08:34:37 +0000
X-Authority-Analysis: v=2.4 cv=HPPDFptv c=1 sm=1 tr=0 ts=6924189d
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=ujWNxKVE5dX343uAl30YYw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=7T7KSl7uo7wA:10
 a=4vEMbUz4tjps1hWW7IUA:9 a=QEXdDO2ut3YA:10 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:References:Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SN6BtQodztQSJ+WhwDENZPRecE8rNPr6eSX8ZqFq7kM=; b=ymBZM06HiIfergUAs1DNdjxgrq
	QYaU32Ae/Pze0iOrvVRYJyeDiwZ6Lj8u1LUDHOkdRqGkGmrzAoRVz8EoMMTfDejwn5gf4BHr/yN01
	cxd29+g/uEvZZRv/fe9naB3uW4U2Rjz1LQvYY5ktDvko/B4yPcNu84nLC6aGhOuEiPaGf7+UlFFIX
	XsfCWaLJ+Dir9UqtdpiQ/szPuC36FCOJe4nboegKLHQw/11k3xhPmWAIVw0nmGmd7s3tSfKRqBlt2
	sYtVuxBjDBOKGh8Wrfn537Hi2kL+4xzjfI1bTEIY3gXIAr1KUQiy4/xcLBoO9OKvTmLyUYYtCTKKO
	po2K6T1g==;
Received: from i118-18-233-1.s41.a027.ap.plala.or.jp ([118.18.233.1]:63980 helo=[10.221.86.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1vNS1r-00000003o5C-2gqj;
	Mon, 24 Nov 2025 02:34:36 -0600
Message-ID: <da074ecc-e688-493e-bd63-76cd88e1ff0f@embeddedor.com>
Date: Mon, 24 Nov 2025 17:34:18 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] bcache: Avoid -Wflex-array-member-not-at-end
 warning
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Coly Li <colyli@fnnas.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-bcache@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <aRHFchrO3BmVMH5c@kspp>
 <7g2dkwi2nzxe2luykodsknobzr5bkl23d5mbahkyo7adhg55oy@6uisoc7jzgy6>
 <a956504a-55af-4c2c-95a0-15663435624a@embeddedor.com>
 <7zweggwc6mkksyhxzbdsphachjj5pzlaebli6xitryfl4yiqdj@eziyaibeuhza>
 <fbef561c-c470-47d0-9bc0-c565e10b2856@embeddedor.com>
Content-Language: en-US
In-Reply-To: <fbef561c-c470-47d0-9bc0-c565e10b2856@embeddedor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 118.18.233.1
X-Source-L: No
X-Exim-ID: 1vNS1r-00000003o5C-2gqj
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: i118-18-233-1.s41.a027.ap.plala.or.jp ([10.221.86.44]) [118.18.233.1]:63980
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHfdpSsVSdbFZ9x5cPMlBUVMQXeh3Vay8faEEeJqGCVz/e8jn4Yyd6UbjefjG5wipZESxYU415wh5EBBRNcV879csWsU/cq+4bZiWg3+29q/a8vB0cR7
 hJSa/otwNqBpi3LstcBC8iRCmXCocp7lqaKgZSlBnEbVcQkF5UIpYBRVq3nkn+a2rd3QAtJMt1K10/czaHPTB+jxxtV4PV0fGXxmDHoc1jZ6efSZMnW7QDiW



On 11/13/25 13:24, Gustavo A. R. Silva wrote:
> 
>> I see. I take this patch, with the above complain...
> 
> Thanks, Coly.

BTW, I'm currently looking into the following struct, and I wonder if
it's okay to move struct bkey end; to the end.

drivers/md/bcache/bset.h:157:struct bset_tree {
drivers/md/bcache/bset.h-158-   /*
drivers/md/bcache/bset.h-159-    * We construct a binary tree in an array as if the array
drivers/md/bcache/bset.h-160-    * started at 1, so that things line up on the same cachelines
drivers/md/bcache/bset.h-161-    * better: see comments in bset.c at cacheline_to_bkey() for
drivers/md/bcache/bset.h-162-    * details
drivers/md/bcache/bset.h-163-    */
drivers/md/bcache/bset.h-164-
drivers/md/bcache/bset.h-165-   /* size of the binary tree and prev array */
drivers/md/bcache/bset.h-166-   unsigned int            size;
drivers/md/bcache/bset.h-167-
drivers/md/bcache/bset.h-168-   /* function of size - precalculated for to_inorder() */
drivers/md/bcache/bset.h-169-   unsigned int            extra;
drivers/md/bcache/bset.h-170-
drivers/md/bcache/bset.h-171-   /* copy of the last key in the set */
drivers/md/bcache/bset.h-172-   struct bkey             end;
drivers/md/bcache/bset.h-173-   struct bkey_float       *tree;
drivers/md/bcache/bset.h-174-
drivers/md/bcache/bset.h-175-   /*
drivers/md/bcache/bset.h-176-    * The nodes in the bset tree point to specific keys - this
drivers/md/bcache/bset.h-177-    * array holds the sizes of the previous key.
drivers/md/bcache/bset.h-178-    *
drivers/md/bcache/bset.h-179-    * Conceptually it's a member of struct bkey_float, but we want
drivers/md/bcache/bset.h-180-    * to keep bkey_float to 4 bytes and prev isn't used in the fast
drivers/md/bcache/bset.h-181-    * path.
drivers/md/bcache/bset.h-182-    */
drivers/md/bcache/bset.h-183-   uint8_t                 *prev;
drivers/md/bcache/bset.h-184-
drivers/md/bcache/bset.h-185-   /* The actual btree node, with pointers to each sorted set */
drivers/md/bcache/bset.h-186-   struct bset             *data;
drivers/md/bcache/bset.h-187-};

Something like this:

diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
index 6ee2c6a506a2..e6daeb0edc02 100644
--- a/drivers/md/bcache/bset.h
+++ b/drivers/md/bcache/bset.h
@@ -169,7 +169,6 @@ struct bset_tree {
         unsigned int            extra;

         /* copy of the last key in the set */
-       struct bkey             end;
         struct bkey_float       *tree;

         /*
@@ -184,6 +183,9 @@ struct bset_tree {

         /* The actual btree node, with pointers to each sorted set */
         struct bset             *data;
+
+       /* Must be last as it ends in a flexible-array member. */
+       struct bkey             end;
  };

This would fix 15 more -Wflex-array-member-not-at-end warnings.

Thanks
-Gustavo

