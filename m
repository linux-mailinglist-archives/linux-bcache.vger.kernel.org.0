Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFF8374DEC
	for <lists+linux-bcache@lfdr.de>; Thu,  6 May 2021 05:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhEFD2G (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 May 2021 23:28:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:59932 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229725AbhEFD2F (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 May 2021 23:28:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3DE47B01C;
        Thu,  6 May 2021 03:27:07 +0000 (UTC)
Subject: Re: [PATCH -next v4] bcache: Use DEFINE_MUTEX() for mutex lock
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     Hulk Robot <hulkci@huawei.com>, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210505110655.1461896-1-zhengyongjun3@huawei.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <8a60b85c-b4c3-5b4c-af1f-877980800ba7@suse.de>
Date:   Thu, 6 May 2021 11:27:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210505110655.1461896-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/5/21 7:06 PM, Zheng Yongjun wrote:
> Mutex lock can be initialized automatically with DEFINE_MUTEX() rather
> than explicitly calling mutex_init().
> 
> This patch will reduce the size of bcache.ko about 16 bytes, the
> reason as follows:
> 
> Though this patch will increase the size of .data segment about 32
> bytes, it will also reduce the size of .init.text and
> .rodata.str1.1(at x86_64), .rodata_str1.8(at arm64) total about 48
> bytes which reduce the size more than .data segment;
> 
> Here is the statistics:
> Sections: (arm64 platform)
> Idx name                size
> -.init.text             00000240
> +.init.text             00000228
> 
> -.rodata.str1.8	000012cd
> +.rodata.str1.8	000012b5
> 
> -.data                  00000c60
> +.data                  00000c80
> 
> Sections: (x86 platform)
> Idx name                size
> -.init.text             000001d9
> +.init.text             000001bf
> 
> -.rodata.str1.1	00000c80
> +.rodata.str1.1	00000c6d
> 
> -.data                  00000cc0
> +.data                  00000ce0
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Added in my for-test queue.

Thanks.

Coly Li

[snipped]
