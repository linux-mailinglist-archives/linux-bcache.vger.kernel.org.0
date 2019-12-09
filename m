Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9D09116A59
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Dec 2019 10:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfLIJ7U (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Dec 2019 04:59:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:60674 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726377AbfLIJ7U (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Dec 2019 04:59:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D4F96ADAD;
        Mon,  9 Dec 2019 09:59:18 +0000 (UTC)
Subject: Re: bcache kbuild cleanups
To:     Christoph Hellwig <hch@lst.de>
Cc:     kent.overstreet@gmail.com, liangchen.linux@gmail.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20191209093829.19703-1-hch@lst.de>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <b19f677f-d8e5-44af-0575-d1fb74835c65@suse.de>
Date:   Mon, 9 Dec 2019 17:59:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191209093829.19703-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/12/9 5:38 下午, Christoph Hellwig wrote:
> Hi Coly and Liang,
> 
> can you review this series to sort out the bcache superblock reading for
> larger page sizes?  I don't have bcache test setup so this is compile
> tested only.
> 
Hi Christoph,

At first glance the patches are good. I will add them into my for-test
directory and test with other development patches.

Thanks for handling this.

-- 

Coly Li
