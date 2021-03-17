Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAE133E88C
	for <lists+linux-bcache@lfdr.de>; Wed, 17 Mar 2021 05:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCQErW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 17 Mar 2021 00:47:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:34482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhCQErF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 Mar 2021 00:47:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 61688AC17;
        Wed, 17 Mar 2021 04:47:04 +0000 (UTC)
Subject: Re: [PATCH] md: bcache: Trivial typo fixes in the file journal.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     rdunlap@infradead.org, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210317043018.4097983-1-unixbhaskar@gmail.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <f191b8a5-e168-a415-1e07-b49d229d7b64@suse.de>
Date:   Wed, 17 Mar 2021 12:47:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210317043018.4097983-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/17/21 12:30 PM, Bhaskar Chowdhury wrote:
> 
> s/condidate/candidate/
> s/folowing/following/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

I will add it in my for-next queue.

Thanks.

Coly Li


> ---
>  drivers/md/bcache/journal.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index c6613e817333..9f2eb8dec803 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -111,7 +111,7 @@ reread:		left = ca->sb.bucket_size - offset;
>  			 * Check from the oldest jset for last_seq. If
>  			 * i->j.seq < j->last_seq, it means the oldest jset
>  			 * in list is expired and useless, remove it from
> -			 * this list. Otherwise, j is a condidate jset for
> +			 * this list. Otherwise, j is a candidate jset for
>  			 * further following checks.
>  			 */
>  			while (!list_empty(list)) {
> @@ -498,7 +498,7 @@ static void btree_flush_write(struct cache_set *c)
>  		 * - If there are matched nodes recorded in btree_nodes[],
>  		 *   they are clean now (this is why and how the oldest
>  		 *   journal entry can be reclaimed). These selected nodes
> -		 *   will be ignored and skipped in the folowing for-loop.
> +		 *   will be ignored and skipped in the following for-loop.
>  		 */
>  		if (((btree_current_write(b)->journal - fifo_front_p) &
>  		     mask) != 0) {
> --
> 2.30.2
> 

