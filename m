Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373D9533654
	for <lists+linux-bcache@lfdr.de>; Wed, 25 May 2022 07:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243228AbiEYFR3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 25 May 2022 01:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237251AbiEYFR2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 25 May 2022 01:17:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18ADF1D337;
        Tue, 24 May 2022 22:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ORCevp/tRYR+5ie3gSlKpqnAjhYaXXhYx2a0A9SefGU=; b=jdUNCx/lsHofSSntrwGLVasMKx
        ChRvM30294qE5sohPXp4MkqBi87vQqwCXVea6KdTjBNQYrOi6iulgUwOavj8ufjMiqR29mpKoypSH
        Vc7k3tcFlo1uPDQkYEip6VBBqeG1KY3STmpTwUrymhZ+ajieSqCNvn4ndsRwyjw8wMGOf9xov42M0
        aCl9Gu6rKX/jqemXQESX5pb82QAGjkpym6w/3KKWZ3Pl02JuJZK3ThUHrQd+rPWxGyR1JUZbVwAbT
        Q3U512pxexkehL2yGaguAx1ZHdiexjYVLDmv3mIxasMoEyRNr/Wq2soBnmXSNevax3t//2gWyG5uT
        4V9vR75w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntjOZ-009xyi-AN; Wed, 25 May 2022 05:17:19 +0000
Date:   Tue, 24 May 2022 22:17:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Christoph Hellwig <hch@infradead.org>, Coly Li <colyli@suse.de>,
        Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>,
        linux-block@vger.kernel.org
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
Message-ID: <Yo273y/q8P6+tUJq@infradead.org>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com>
 <958894243.922478.1652201375900@mail.yahoo.com>
 <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
 <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net>
 <YoxuYU4tze9DYqHy@infradead.org>
 <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, May 24, 2022 at 01:14:18PM -0700, Eric Wheeler wrote:
> Adriano was getting 1.5ms sync-write ioping's to an NVMe through bcache 
> (instead of the expected ~70us), so perhaps the NVMe flushes were killing 
> performance if every write was also forcing an erase cycle.

This sounds very typical of a low end consumer grade NVMe SSD, yes.

> The suggestion was to disable flushes in bcache as a troubleshooting step 
> to see if that solved the problem, but with the warning that it could be 
> unsafe.

If you want to disable the cache (despite this being unsafe!) you can
do this for every block device:

	echo "write through" > /sys/block/XXX/queue/write_cache

> Questions:
> 
> 1. If a user knows their disks have a non-volatile cache then is it safe 
>    to drop flushes?

It is, but in that case the disk will not advertise a write cache, and
the flushes will not make it past the submit_bio and never reach the
driver.

> 3. Since the block layer wont send flushes when the hardware reports that 
>    the cache is non-volatile, then how do you query the device to make 
>    sure it is reporting correctly?  For NVMe you can get VWC as:
> 	nvme id-ctrl -H /dev/nvme0 |grep -A1 vwc
>    
>    ...but how do you query a block device (like a RAID LUN) to make sure 
>    it is reporting a non-volatile cache correctly?

cat /sys/block/XXX/queue/write_cache
