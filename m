Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12973B09FE
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Jun 2021 18:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhFVQMv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Jun 2021 12:12:51 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56250 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhFVQMs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Jun 2021 12:12:48 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BB9A12196C;
        Tue, 22 Jun 2021 16:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624378231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OBsiPuL7h3qkYc/fzzIiZgnMwkZnm2LoFEaxuYiK7oU=;
        b=0qpUDOz/k6ZY3yfuY681vkq6Y0DDYra8sUKngniDbHSZA9WWr9yeh44EWcnKBHyuIBHw6/
        NtJe7XPyzDkthNliUvKxwF62SZ0S32+VeHg+aRcW3STKsNJQOhpuFqlUxAF8MxtPSLqZEh
        KHgVsPxZoVqmWgU/MEZXlJGEP1jBhDw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624378231;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OBsiPuL7h3qkYc/fzzIiZgnMwkZnm2LoFEaxuYiK7oU=;
        b=XtIutccXexZz64VEqwafXQ1xCTbg+rpiSuXnTbnMgzb57ucrRTsLr9bpveTi/D68k2aWHK
        7xz2JtekQXzhPTBg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 7861111A97;
        Tue, 22 Jun 2021 16:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624378231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OBsiPuL7h3qkYc/fzzIiZgnMwkZnm2LoFEaxuYiK7oU=;
        b=0qpUDOz/k6ZY3yfuY681vkq6Y0DDYra8sUKngniDbHSZA9WWr9yeh44EWcnKBHyuIBHw6/
        NtJe7XPyzDkthNliUvKxwF62SZ0S32+VeHg+aRcW3STKsNJQOhpuFqlUxAF8MxtPSLqZEh
        KHgVsPxZoVqmWgU/MEZXlJGEP1jBhDw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624378231;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OBsiPuL7h3qkYc/fzzIiZgnMwkZnm2LoFEaxuYiK7oU=;
        b=XtIutccXexZz64VEqwafXQ1xCTbg+rpiSuXnTbnMgzb57ucrRTsLr9bpveTi/D68k2aWHK
        7xz2JtekQXzhPTBg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id dotLC3QL0mDIHgAALh3uQQ
        (envelope-from <colyli@suse.de>); Tue, 22 Jun 2021 16:10:28 +0000
Subject: Re: [PATCH] md: use BLK_STS_OK instead of hardcode
To:     Xianting Tian <xianting_tian@126.com>
Cc:     linux-bcache@vger.kernel.org, agk@redhat.com, snitzer@redhat.com,
        kent.overstreet@gmail.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        song@kernel.org, dm-devel@redhat.com
References: <1624377241-8642-1-git-send-email-xianting_tian@126.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <930e7a23-a22e-409f-e058-0b1576c5d9d0@suse.de>
Date:   Wed, 23 Jun 2021 00:10:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1624377241-8642-1-git-send-email-xianting_tian@126.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/22/21 11:54 PM, Xianting Tian wrote:
> When setting io status, sometimes it uses BLK_STS_*, sometimes,
> it uses hardcode 0.
> Use the macro to replace hardcode in multiple places.
>
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>  drivers/md/bcache/request.c  | 2 +-
>  drivers/md/dm-clone-target.c | 2 +-
>  drivers/md/dm-integrity.c    | 2 +-
>  drivers/md/dm-mpath.c        | 2 +-
>  drivers/md/dm-raid1.c        | 2 +-
>  drivers/md/dm.c              | 2 +-
>  drivers/md/raid1.c           | 4 ++--
>  drivers/md/raid10.c          | 2 +-
>  8 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 6d1de88..73ba5a6 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -790,7 +790,7 @@ static void cached_dev_read_error(struct closure *cl)
>  		/* Retry from the backing device: */
>  		trace_bcache_read_retry(s->orig_bio);
>  
> -		s->iop.status = 0;
> +		s->iop.status = BLK_STS_OK;
>  		do_bio_hook(s, s->orig_bio, backing_request_endio);
>  
>  		/* XXX: invalidate cache */

Hi Xianting,

NACK for bcache part.

The change is incomplete, if you want to replace 0 by BLK_STS_OK, you
should check all locations
where s->iop.status is checked and replace with BLK_STS_OK when necessary.

One but not the only one example is,
871         if (s->iop.status)
872                 continue_at_nobarrier(cl, cached_dev_read_error,
bcache_wq);
Maybe you should change to
        if (s->iop.status != BLK_STS_OK)
                    continue_at_nobarrier(cl, cached_dev_read_error,
bcache_wq);


Just FYI.

Coly Li
