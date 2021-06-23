Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359803B13AF
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 08:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFWGJF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 02:09:05 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42826 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhFWGJF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 02:09:05 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D9C652195F;
        Wed, 23 Jun 2021 06:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624428407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+HAh3OoP1/VdciYMX2yL77jLAHkQg+ySgxvFHYHw6UA=;
        b=pTy5VfhEEO5w7OYJbuy/LnyrzhEmmyWoG+PQxEXw87xRU45TGZTF57UFMkxXIJ5jtVQ/NI
        v3hgeONbWLlqDxfktULLJU72RN9rcdSW2W9fHKFwVy1lzajvPJm43jWud/tF2AESNwBpzn
        hIc5pXhuTRYHXrfOCXOiLUtlARAhIx0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624428407;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+HAh3OoP1/VdciYMX2yL77jLAHkQg+ySgxvFHYHw6UA=;
        b=Gss5FKEXrIFpcbHXKbAOGdZRBEsDMBJIKJY96kSBYQTNWzMXCdNzUDZjAaNzN0F7SCYswS
        sbezWHXoWhZtj6Cw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 830AA11A97;
        Wed, 23 Jun 2021 06:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624428407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+HAh3OoP1/VdciYMX2yL77jLAHkQg+ySgxvFHYHw6UA=;
        b=pTy5VfhEEO5w7OYJbuy/LnyrzhEmmyWoG+PQxEXw87xRU45TGZTF57UFMkxXIJ5jtVQ/NI
        v3hgeONbWLlqDxfktULLJU72RN9rcdSW2W9fHKFwVy1lzajvPJm43jWud/tF2AESNwBpzn
        hIc5pXhuTRYHXrfOCXOiLUtlARAhIx0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624428407;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+HAh3OoP1/VdciYMX2yL77jLAHkQg+ySgxvFHYHw6UA=;
        b=Gss5FKEXrIFpcbHXKbAOGdZRBEsDMBJIKJY96kSBYQTNWzMXCdNzUDZjAaNzN0F7SCYswS
        sbezWHXoWhZtj6Cw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id o5u9FHbP0mCwXQAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 06:06:46 +0000
Subject: Re: [PATCH 07/14] bcache: bch_nvm_free_pages() of the buddy
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-bcache@vger.kernel.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-8-colyli@suse.de>
 <327edd3d-c239-9099-5e2a-448dcc7a972f@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <181966fc-14e1-d690-3128-daf41471939e@suse.de>
Date:   Wed, 23 Jun 2021 14:06:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <327edd3d-c239-9099-5e2a-448dcc7a972f@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/22/21 6:53 PM, Hannes Reinecke wrote:
> On 6/15/21 7:49 AM, Coly Li wrote:
>> From: Jianpeng Ma <jianpeng.ma@intel.com>
>>
>> This patch implements the bch_nvm_free_pages() of the buddy.
>>
>> The difference between this and page-buddy-free:
>> it need owner_uuid to free owner allocated pages.And must
>> persistent after free.
>>
>> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
>> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>  drivers/md/bcache/nvm-pages.c | 164 ++++++++++++++++++++++++++++++++--
>>  drivers/md/bcache/nvm-pages.h |   3 +-
>>  2 files changed, 159 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
>> index 5d095d241483..74d08950c67c 100644
>> --- a/drivers/md/bcache/nvm-pages.c
>> +++ b/drivers/md/bcache/nvm-pages.c
>> @@ -52,7 +52,7 @@ static void release_nvm_set(struct bch_nvm_set *nvm_set)
>>  	kfree(nvm_set);
>>  }
>>  
>> -static struct page *nvm_vaddr_to_page(struct bch_nvm_namespace *ns, void *addr)
>> +static struct page *nvm_vaddr_to_page(void *addr)
>>  {
>>  	return virt_to_page(addr);
>>  }
> If you don't need this argument please modify the patch adding the
> nvm_vaddr_to_page() function.

Copied. We will add the patch where  nvm_vaddr_to_page() was firstly
added in.

It will be updated in next post.

Thanks for your review.

Coly Li


[snipped]
