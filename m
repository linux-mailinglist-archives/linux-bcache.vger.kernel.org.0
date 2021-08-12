Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F033EA089
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Aug 2021 10:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhHLI05 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 12 Aug 2021 04:26:57 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:54808 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbhHLI05 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Aug 2021 04:26:57 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BE8731FF25;
        Thu, 12 Aug 2021 08:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628756791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W1siwlHTi8lS3cs+jZ0WTisGvn3OxGPBwciL9B3Rt4s=;
        b=aSSDMf2s/7P5tBjB9VJ/z0vKpyZTppPkSJ8XLfBBqff1ejuaHy9Kv4N86QnWwp1Pq6lvfB
        bBVUgx94DhRPKRD9vd9s0CQBFPHFlfYtYjdDkVXkRAzuoSwyoJsQXlc43wOUemAniEI8qm
        ZMQjDDS92Lx44PF2NYIdCak9Iy8ssnI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628756791;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W1siwlHTi8lS3cs+jZ0WTisGvn3OxGPBwciL9B3Rt4s=;
        b=1paF8yPysFFCRHMIqOFoGezeXpOaxgGYAvQrNFvMTQSOWDwbwlUVVU35rH8zOq/Cq0P+yw
        9CKla2iY9VnjiaAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B98CE13A09;
        Thu, 12 Aug 2021 08:26:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nErhIDTbFGHkKwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 12 Aug 2021 08:26:28 +0000
Subject: Re: [PATCH v12 02/12] bcache: initialize the nvm pages allocator
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvdimm@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        "Huang, Ying" <ying.huang@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Hannes Reinecke <hare@suse.de>
References: <20210811170224.42837-1-colyli@suse.de>
 <20210811170224.42837-3-colyli@suse.de>
 <CAPcyv4hhfg=mgN4AW8T2VWGVbKsQZkpPwpU5yVAVh2nFOxCBcg@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <dffaf01e-9ac4-e71b-3e38-1f2b0bfc5aed@suse.de>
Date:   Thu, 12 Aug 2021 16:26:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hhfg=mgN4AW8T2VWGVbKsQZkpPwpU5yVAVh2nFOxCBcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/12/21 1:43 PM, Dan Williams wrote:
> On Wed, Aug 11, 2021 at 10:04 AM Coly Li <colyli@suse.de> wrote:
>> From: Jianpeng Ma <jianpeng.ma@intel.com>
>>
>> This patch define the prototype data structures in memory and
>> initializes the nvm pages allocator.
>>
>> The nvm address space which is managed by this allocator can consist of
>> many nvm namespaces, and some namespaces can compose into one nvm set,
>> like cache set. For this initial implementation, only one set can be
>> supported.
>>
>> The users of this nvm pages allocator need to call register_namespace()
>> to register the nvdimm device (like /dev/pmemX) into this allocator as
>> the instance of struct nvm_namespace.
>>
>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
>> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> ---
>>  drivers/md/bcache/Kconfig     |  10 +
>>  drivers/md/bcache/Makefile    |   1 +
>>  drivers/md/bcache/nvm-pages.c | 339 ++++++++++++++++++++++++++++++++++
>>  drivers/md/bcache/nvm-pages.h |  96 ++++++++++
>>  drivers/md/bcache/super.c     |   3 +
>>  5 files changed, 449 insertions(+)
>>  create mode 100644 drivers/md/bcache/nvm-pages.c
>>  create mode 100644 drivers/md/bcache/nvm-pages.h
>>
[snipped]
>> +
>> +       err = -EOPNOTSUPP;
>> +       if (!bdev_dax_supported(bdev, ns->page_size)) {
>> +               pr_err("%s don't support DAX\n", bdevname(bdev, buf));
>> +               goto free_ns;
>> +       }
>> +
>> +       err = -EINVAL;
>> +       if (bdev_dax_pgoff(bdev, 0, ns->page_size, &pgoff)) {
>> +               pr_err("invalid offset of %s\n", bdevname(bdev, buf));
>> +               goto free_ns;
>> +       }
>> +
>> +       err = -ENOMEM;
>> +       ns->dax_dev = fs_dax_get_by_bdev(bdev);
>> +       if (!ns->dax_dev) {
>> +               pr_err("can't by dax device by %s\n", bdevname(bdev, buf));
>> +               goto free_ns;
>> +       }
>> +
>> +       err = -EINVAL;
>> +       id = dax_read_lock();
>> +       dax_ret = dax_direct_access(ns->dax_dev, pgoff, ns->pages_total,
>> +                                   &ns->base_addr, &ns->start_pfn);
>> +       if (dax_ret <= 0) {
>> +               pr_err("dax_direct_access error\n");
>> +               dax_read_unlock(id);
>> +               goto free_ns;
>> +       }
>> +
>> +       if (dax_ret < ns->pages_total) {
>> +               pr_warn("mapped range %ld is less than ns->pages_total %lu\n",
>> +                       dax_ret, ns->pages_total);

Hi Dan,

Many thanks for your information.

> This failure will become a common occurrence with CXL namespaces that
> will have discontiguous range support. It's already the case for
> dax-devices for soft-reserved memory [1]. In the CXL case the
> discontinuity will be 256MB aligned, for the soft-reserved dax-devices
> the discontinuity granularity can be as small as 4K.
>
> [1]: https://elixir.bootlin.com/linux/v5.14-rc5/source/drivers/dax/device.c#L414

Fortunately the on-media allocation list format works with multiple
ranges of the namespace. For the in-memory struct bch_nvmpg_ns currently
assumes the namespace is a flat continuous range. Yes, we need to
consider and support multiple ranges in struct bch_nvmpg_ns for buddy
allocation initialization to skip the discontinuous gap.

It will be in the to-do list for next work. Thanks for your comments and
hint.

Coly Li
