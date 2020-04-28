Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C751BCA43
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Apr 2020 20:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730831AbgD1SsZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 28 Apr 2020 14:48:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49077 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730963AbgD1Sk6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Apr 2020 14:40:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588099257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4IhIJ7/e3VDH321W4uVTvr/gfrTSIY3xCZQuvN2kwiA=;
        b=N+WnqWVX+5qtBzKsJm8mWzS57E/AXUXsTl+JXKpehG+oyklcwaPx5LWKkv+Fvk3xecyK2d
        57Mb4blpMW94qDkx1rQR2Gd+EZK3cshfnBHD97KYON70dkfx6bccAn3pTVq0D76vIg/ZM5
        0l9oYwzr8mdmkuaGrk8ZJmNmGNpKajs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-4RG9HmGTOEun38Rst9DCTA-1; Tue, 28 Apr 2020 14:40:53 -0400
X-MC-Unique: 4RG9HmGTOEun38Rst9DCTA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CF3C462;
        Tue, 28 Apr 2020 18:40:52 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D80941C950;
        Tue, 28 Apr 2020 18:40:48 +0000 (UTC)
Date:   Tue, 28 Apr 2020 14:40:47 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-bcache@vger.kernel.org
Subject: Re: [PATCH 3/3] block: bypass ->make_request_fn for blk-mq drivers
Message-ID: <20200428184047.GB17609@redhat.com>
References: <20200425075336.721021-1-hch@lst.de>
 <20200425075336.721021-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425075336.721021-4-hch@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, Apr 25 2020 at  3:53am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Call blk_mq_make_request when no ->make_request_fn is set.  This is
> safe now that blk_alloc_queue always sets up the pointer for make_request
> based drivers.  This avoids an indirect call in the blk-mq driver I/O
> fast path, which is rather expensive due to spectre mitigations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes me cringe thinking about all the indirect calls sprinkled
throughout DM...

Acked-by: Mike Snitzer <snitzer@redhat.com>

