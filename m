Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111AC166367
	for <lists+linux-bcache@lfdr.de>; Thu, 20 Feb 2020 17:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgBTQsK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 20 Feb 2020 11:48:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:46326 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728145AbgBTQsK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 20 Feb 2020 11:48:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 67A7FAAC7;
        Thu, 20 Feb 2020 16:48:08 +0000 (UTC)
Subject: Re: [PATCH 1/3] bcache: ignore pending signals when creating gc and
 allocator thread
To:     Christoph Hellwig <hch@infradead.org>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20200213141207.77219-1-colyli@suse.de>
 <20200213141207.77219-2-colyli@suse.de>
 <20200219163200.GA18377@infradead.org>
 <1f6cd622-3476-068b-3593-f918ab011156@suse.de>
 <20200220163803.GA12147@infradead.org>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <b2f997ce-3b47-19ec-439d-e29a35ff7ef4@suse.de>
Date:   Fri, 21 Feb 2020 00:47:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200220163803.GA12147@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/2/21 12:38 上午, Christoph Hellwig wrote:
> On Thu, Feb 20, 2020 at 09:20:49PM +0800, Coly Li wrote:
>> Therefore I need to explicitly call pending_signal() before calling
>> kthread_run().
> 
> Right now you have to.  But the proper fix is to not require this and
> fix kthread_run to work from a thread that has been selected by the OOM
> killer.  In the most trivial version by moving your code into
> kthread_run, but there probably are better ways as well.
> 

Yes I see. Let me think about it, at this moment kthread_run() is still
not very clear in my mind.

Thanks for the hint.

-- 

Coly Li
