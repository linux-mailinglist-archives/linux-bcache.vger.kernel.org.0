Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55813E064C
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Aug 2021 19:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239749AbhHDRFd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Aug 2021 13:05:33 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56770 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239695AbhHDRFc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Aug 2021 13:05:32 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 87CC22226C;
        Wed,  4 Aug 2021 17:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628096717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LZP5mbUaD4tLAM/AkhQwADJlhMUwxJoQ/fOe4VFqGiM=;
        b=T28M0ZzaVol9YE3Im9Ef1mW1D7DzmcvFlTfm+U3I6h9FX8vh3AkbVlkZFRYSdqJtek/+0x
        dI3DWubXqGVFB7wCjGMMp3YpUY0PLxtnKXLrO4UFOKWVXWoEisnr9ymd2Q+ibiGfXn7xYW
        yN1YDv9rZpfydqtAGq/FdJrpbfRlczY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628096717;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LZP5mbUaD4tLAM/AkhQwADJlhMUwxJoQ/fOe4VFqGiM=;
        b=t/keDuDOz4izQ9+Pevp8W+FaYqjWV9O9Grio2dEGxQV6iGJHmdZQ208YpuRM80KcNSr8MP
        me7eM4q47pic8fDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6E66913D1F;
        Wed,  4 Aug 2021 17:05:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +P54DsjICmHSHgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 04 Aug 2021 17:05:12 +0000
Subject: Re: [PATCH 09/15] bcache: use bvec_virt
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Song Liu <song@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-um@lists.infradead.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20210804095634.460779-1-hch@lst.de>
 <20210804095634.460779-10-hch@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <13eb9def-5db4-d776-2b5a-0096a0a2a681@suse.de>
Date:   Thu, 5 Aug 2021 01:05:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804095634.460779-10-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/4/21 5:56 PM, Christoph Hellwig wrote:
> Use bvec_virt instead of open coding it.  Note that the existing code is
> fine despite ignoring bv_offset as the bio is known to contain exactly
> one page from the page allocator per bio_vec.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>  drivers/md/bcache/btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 183a58c89377..0595559de174 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -378,7 +378,7 @@ static void do_btree_node_write(struct btree *b)
>  		struct bvec_iter_all iter_all;
>  
>  		bio_for_each_segment_all(bv, b->bio, iter_all) {
> -			memcpy(page_address(bv->bv_page), addr, PAGE_SIZE);
> +			memcpy(bvec_virt(bv), addr, PAGE_SIZE);
>  			addr += PAGE_SIZE;
>  		}
>  

