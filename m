Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20783ECA2B
	for <lists+linux-bcache@lfdr.de>; Sun, 15 Aug 2021 18:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhHOQWa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 15 Aug 2021 12:22:30 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52146 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhHOQW3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 15 Aug 2021 12:22:29 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CDF8D1FE3F;
        Sun, 15 Aug 2021 16:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629044517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hl/3xsL3EoM48kHqH0YKlrxAEsZuyhj8gEIz+8wIG08=;
        b=CpEWxEt5fLCxd1JY4r52Kz8BRGlsNaSzocQH7dKkxbEysObe2fJBWWoIS/TpWR0+fiXPUZ
        AHhaaqq7diIjZUjbOgO1PiQgmWfpuXtAhAR+fmewpmwkUnp/DWawKCKas/hL2liEcAlspp
        5+i0dpdJ8oa4cg9ZD/LqQwoWAZMH2UI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629044517;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hl/3xsL3EoM48kHqH0YKlrxAEsZuyhj8gEIz+8wIG08=;
        b=OSSJ47b0L+pmOTjANiS6EjHsgZrjnMFyLDUoXYrBp+trr7ohBffb/8POJcVgR64FEh/FG7
        4WVuJd4YYtzvmdCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0628F13D22;
        Sun, 15 Aug 2021 16:21:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UWOHMCM/GWHMOwAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 15 Aug 2021 16:21:55 +0000
Subject: Re: [PATCH v12 00/12] bcache: support NVDIMM for journaling
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.linux.dev,
        hare@suse.com, jack@suse.cz, dan.j.williams@intel.com, hch@lst.de,
        ying.huang@intel.com, linux-bcache@vger.kernel.org
References: <20210811170224.42837-1-colyli@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <ba63e57f-ccf0-dbb2-6133-388738b6c28a@suse.de>
Date:   Mon, 16 Aug 2021 00:21:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210811170224.42837-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

Could you please consider take the v12 series for Linux v5.15 merge window?

In this version the full pointer in the on-media data structures are
modified to per-namespace offset, and all previous review comments are
fixed.
There is no more comments for 4 hours, and this series survives in my
smoking test for 24+ hours, as an EXPERIMENTAL code the current status
is fine IMHO.

Thanks in advance.

Coly Li


On 8/12/21 1:02 AM, Coly Li wrote:
> This is the v12 effort for supporting NVDIMM for bcache journal (some
> versions may not posted with version numbers).
>
> The major change of this version is the full pointer of on-media data
> structure is replaced by per-namespace offset. Now a pointer address is
> calculated by namespace base mapping address + per-namespace offset.
> The code logic is same as previous version, all changes are only related
> to the base+offset style pointer replacement.
>
> The nvm-pages allocator is a buddy-like allocator, which allocates size
> in power-of-2 pages from the NVDIMM namespace. User space tool 'bcache'
> has a new added '-M' option to format a NVDIMM namespace and register it
> via sysfs interface as a bcache meta device. The nvm-pages kernel code
> does a DAX mapping to map the whole namespace into system's memory
> address range, and allocating the pages to requestion like typical buddy
> allocator does. The major difference is nvm-pages allocator maintains
> the pages allocated to each requester by an allocation list which stored
> on NVDIMM too. Allocation list of different requester is tracked by a
> pre-defined UUID, all the pages tracked in all allocation lists are
> treated as allocated busy pages and won't be initialized into buddy
> system after the system reboot.
>
> The bcache journal code may request a block of power-of-2 size pages
> from the nvm-pages allocator, normally it is a range of 256MB or 512MB
> continuous pages range. During meta data journaling, the in-memory jsets
> go into the calculated nvdimm pages location by kernel memcpy routine.
> So the journaling I/Os won't go into block device (e.g. SSD) anymore, 
> the write and read for journal jsets happen on NVDIMM.
>
> Intel developers Jianpeng Ma and Qiaowei Ren compose the initial code of
> nvm-pages, the related patches are,
> - bcache: initialize the nvm pages allocator
> - bcache: initialization of the buddy
> - bcache: bch_nvm_alloc_pages() of the buddy
> - bcache: bch_nvm_free_pages() of the buddy
> - bcache: get recs list head for allocated pages by specific uuid
> All the code depends on Linux libnvdimm and dax drivers, the bcache nvm-
> pages allocator can be treated as user of these two drivers.
>
> I modify the bcache code to recognize the nvm meta device feature,
> initialize journal on NVDIMM, and do journal I/Os on NVDIMM in the
> following patches,
> - bcache: add initial data structures for nvm pages
> - bcache: use bucket index to set GC_MARK_METADATA for journal buckets
>   in bch_btree_gc_finish()
> - bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
> - bcache: initialize bcache journal for NVDIMM meta device
> - bcache: support storing bcache journal into NVDIMM meta device
> - bcache: read jset from NVDIMM pages for journal replay
> - bcache: add sysfs interface register_nvdimm_meta to register NVDIMM
>   meta device
>
> In this series, all previously addressed issue via code reviews are all
> fixed. And all known issue during testing are fixed. The code survives
> from 24+ hours smoking and I/O pressure testing among many reboots, it
> works well as expected.
>
> All the code is EXPERIMENTAL, they won't be enabled by default until we
> feel the NVDIMM support is completed and stable.
>
> Although there are some experts helped to review the code logic, but we
> do appreciate if more people may help to review the code. It is quite
> common that bcache patches don't have enough code reviewer, but this
> time I do need help for more review or comments on this series.
>
> Thanks in advance.
>
> Coly Li
> ---
>
> Coly Li (7):
>   bcache: add initial data structures for nvm pages
>   bcache: use bucket index to set GC_MARK_METADATA for journal buckets
>     in bch_btree_gc_finish()
>   bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
>   bcache: initialize bcache journal for NVDIMM meta device
>   bcache: support storing bcache journal into NVDIMM meta device
>   bcache: read jset from NVDIMM pages for journal replay
>   bcache: add sysfs interface register_nvdimm_meta to register NVDIMM
>     meta device
>
> Jianpeng Ma (5):
>   bcache: initialize the nvm pages allocator
>   bcache: initialization of the buddy
>   bcache: bch_nvmpg_alloc_pages() of the buddy
>   bcache: bch_nvmpg_free_pages() of the buddy allocator
>   bcache: get recs list head for allocated pages by specific uuid
>
>  drivers/md/bcache/Kconfig       |  10 +
>  drivers/md/bcache/Makefile      |   1 +
>  drivers/md/bcache/btree.c       |   6 +-
>  drivers/md/bcache/features.h    |   9 +
>  drivers/md/bcache/journal.c     | 325 +++++++++--
>  drivers/md/bcache/journal.h     |   2 +-
>  drivers/md/bcache/nvm-pages.c   | 931 ++++++++++++++++++++++++++++++++
>  drivers/md/bcache/nvm-pages.h   | 127 +++++
>  drivers/md/bcache/super.c       |  53 +-
>  include/uapi/linux/bcache-nvm.h | 253 +++++++++
>  10 files changed, 1649 insertions(+), 68 deletions(-)
>  create mode 100644 drivers/md/bcache/nvm-pages.c
>  create mode 100644 drivers/md/bcache/nvm-pages.h
>  create mode 100644 include/uapi/linux/bcache-nvm.h
>

