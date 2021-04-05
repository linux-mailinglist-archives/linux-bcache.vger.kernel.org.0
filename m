Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F7735481E
	for <lists+linux-bcache@lfdr.de>; Mon,  5 Apr 2021 23:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhDEVRo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 5 Apr 2021 17:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbhDEVRj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 5 Apr 2021 17:17:39 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46E3C061756;
        Mon,  5 Apr 2021 14:17:31 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e18so12028427wrt.6;
        Mon, 05 Apr 2021 14:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=xku8cZgBeg8aMVGdJK4Bl+ZcDI2/rAg1sxUWm6S5t2s=;
        b=ORv65kxqAR8O+DXSh85RYlNzRkEB5ByNG7RqbCOUoM4qwiBA2qoC0PSEDlXb9PpEGt
         R7QvOb7l8qZ94eBsoQuiDFaEZRyx4PZ0wGbaRJZeRO/U/4kH6EItm8JiPoD9VX0I1VIO
         2/ztjnmaHiCLR0+q6dvx48cLtrhMXREI/rrgz/jXrfYqByECueHHsgscCz+nbdqhTyI3
         bcQD6o4lAyi0zkU3K9gy6IRUq+xWJUCznlwg2eVIkKkIXW/E/4qTg5AgiX3nQp0ThPd1
         y/KBA8lFL33Tb4DSjE0BJ4XfqcXjsyEYD9UoCnw9C0CJE1bTk0I/Hqhbs03SDQ7ltQUa
         Kppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=xku8cZgBeg8aMVGdJK4Bl+ZcDI2/rAg1sxUWm6S5t2s=;
        b=e8rM+HYDDmZiIEtUiUUdpTPTNgufpyWLAgM5hgdoE50VcEh6m7Xroi2u81jmMnm+WG
         KG+QrhPZ14AsXajDOio/MKX/9JcqsNesybkEmWOfir8qpTMQGpg+gU8HGZEMj/4mLaFF
         lBFiNUOeHu2wl5ELQlvHPHCnjoMc43Flbe+gdWhlPJcylZiPkI64vxvJc9tRsolxwBkv
         VoA4M8ZxtZ8+Kq/EqtOSNLoqpWH4ldVIEql5U47baCYfca9JeCnMYoptqSInhfV4FiXg
         VfSnrju0cqB+KNQZJdqt0IJ0pmbAmN2vVNF+DW6kqdFWms72EtltfsDUy4xQoOGH1kJN
         m1Mw==
X-Gm-Message-State: AOAM533ZIP1jW+cyKheiNaNT/vgO3ZE13uzam0Wl7vp3b2AQY2u328Cl
        kYiheBGht/xl1EONSs5gN6U=
X-Google-Smtp-Source: ABdhPJzPyw2aLo/F07PLFZIo6xseAqD6+LtSiYrC8iP+ifj6P/SK0B63Y7rjbAFCkgmugXvJP39eHA==
X-Received: by 2002:adf:f64e:: with SMTP id x14mr3872055wrp.203.1617657450513;
        Mon, 05 Apr 2021 14:17:30 -0700 (PDT)
Received: from 192.168.10.5 ([39.46.7.73])
        by smtp.gmail.com with ESMTPSA id u19sm704605wml.28.2021.04.05.14.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 14:17:30 -0700 (PDT)
Message-ID: <d7f70ce31f6f61a50c05a5d5ba03582054f144fe.camel@gmail.com>
Subject: Re: [PATCH -next] bcache: use DEFINE_MUTEX() for mutex lock
From:   Muhammad Usama Anjum <musamaanjum@gmail.com>
To:     Coly Li <colyli@suse.de>, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     musamaanjum@gmail.com, linux-bcache@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Date:   Tue, 06 Apr 2021 02:17:25 +0500
In-Reply-To: <42c3e33d-c20e-0fdd-f316-5084e33f9a3b@suse.de>
References: <20210405101453.15096-1-zhengyongjun3@huawei.com>
         <42c3e33d-c20e-0fdd-f316-5084e33f9a3b@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, 2021-04-05 at 22:02 +0800, Coly Li wrote:
> On 4/5/21 6:14 PM, Zheng Yongjun wrote:
> > mutex lock can be initialized automatically with DEFINE_MUTEX()
> > rather than explicitly calling mutex_init().
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> NACK. This is not the first time people try to "fix" this location...
> 
> Using DEFINE_MUTEX() does not gain anything for us, it will generate
> unnecessary extra size for the bcache.ko.
> ines.

How can the final binary have larger size by just static declaration?
By using DEFINE_MUTEX, the mutex is initialized at compile time. It'll
save initialization at run time and one line of code will be less also
from text section. 

#### with no change (dynamic initialization)
size drivers/md/bcache/bcache.ko
   text	   data	    bss	    dec	    hex	filename
 187792	  25310	    152	 213254	  34106	drivers/md/bcache/bcache.ko

#### with patch applied (static initialization)
   text	   data	    bss	    dec	    hex	filename
 187751	  25342	    120	 213213	  340dd	drivers/md/bcache/bcache.ko

Module's binary size has decreased by 41 bytes with the path applied
(x86_64 arch).



