Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BEA3B147D
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 09:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhFWHVe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 03:21:34 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39878 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWHVd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 03:21:33 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 991301FD65;
        Wed, 23 Jun 2021 07:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624432755; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iXjVZHTm6iYmkYLtXfwhQoGuPDv2WMfBSV2SMtV7mng=;
        b=oyuUq7mBY8cOG/oOGsLH0qW/bsp+XvmbKMIwh+gASZsxTDTX1NtWenCZhP9gp9l8MBuYhG
        qAUub60CvSzpGgg/FSW9cRuFWsgwB9BM3iu4eOUPnE7bFFJ6Zu9oDvEX23DlHfdpZq55ik
        n97LVNJEZ36VlQC0OP8YuIjAtXzdFLM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624432755;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iXjVZHTm6iYmkYLtXfwhQoGuPDv2WMfBSV2SMtV7mng=;
        b=bLRfwgFebDBYoEEm0Pf7vvElgn8ujpDZOru5znpWWR8GgsBEpLvltfe+hmSWA/PjL8fPFe
        t6zJG4d0TTx4IeCQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 71D8E11A97;
        Wed, 23 Jun 2021 07:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624432755; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iXjVZHTm6iYmkYLtXfwhQoGuPDv2WMfBSV2SMtV7mng=;
        b=oyuUq7mBY8cOG/oOGsLH0qW/bsp+XvmbKMIwh+gASZsxTDTX1NtWenCZhP9gp9l8MBuYhG
        qAUub60CvSzpGgg/FSW9cRuFWsgwB9BM3iu4eOUPnE7bFFJ6Zu9oDvEX23DlHfdpZq55ik
        n97LVNJEZ36VlQC0OP8YuIjAtXzdFLM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624432755;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iXjVZHTm6iYmkYLtXfwhQoGuPDv2WMfBSV2SMtV7mng=;
        b=bLRfwgFebDBYoEEm0Pf7vvElgn8ujpDZOru5znpWWR8GgsBEpLvltfe+hmSWA/PjL8fPFe
        t6zJG4d0TTx4IeCQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id duKiCnHg0mB6eQAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 07:19:13 +0000
Subject: Re: Ask help for code review (was Re: [PATCH 03/14] bcache: add
 initial data structures for nvm pages)
To:     Christoph Hellwig <hch@lst.de>,
        "Huang, Ying" <ying.huang@intel.com>
Cc:     Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>,
        Hannes Reinecke <hare@suse.com>, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>, axboe@kernel.dk
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-4-colyli@suse.de>
 <24ad3795-813c-b50b-e983-56dccef1b0db@suse.de>
 <875yy6l2a1.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <b1597c54-16ea-c943-8af7-25c8eab342e9@suse.de>
 <87czsdhy0u.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <20210623070405.GA537@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <f150a8a6-26ee-8fdd-2964-be1254835bc1@suse.de>
Date:   Wed, 23 Jun 2021 15:19:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210623070405.GA537@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/23/21 3:04 PM, Christoph Hellwig wrote:
> Storing a pointer on-media is completely broken.  It is not endian
> clean, not 32-bit vs 64-bit clean and will lead to problems when addresses

Why it is not endian clean, and not 32-bit vs. 64 bit clean for bcache ?
Bcache does not support endian clean indeed, and libnvdimm only works with
64bit physical address width. The only restriction here by using pointer is
the CPU register word should be 64bits, because we use the NVDIMM as memory.

Is it one of the way how NVDIMM (especially Intel AEP) designed to use ?
As a non-volatiled memory.

> change.  And they will change - maybe not often with DDR-attached
> memory, but very certainly with CXL-attached memory that is completely
> hot pluggable.

Does the already mapped DAX base address change in runtime during memory
hot plugable ?
If not, it won't be a problem here for this specific use case.

Coly Li
