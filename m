Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D07521121C
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jul 2020 19:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732803AbgGARme (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jul 2020 13:42:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56626 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732795AbgGARmd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 13:42:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593625352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wobg33Jd/mLzwVfLH+qw23dgCxhuXQvI8VYke7pyLt8=;
        b=gEVH/ITynyVNA9k7Q4RWS0X1g/MNxlRkyslM4uhmumWr6k+zL74K6p1Q7q6Y5SRGi2vnyu
        t+p/VpRZPNSvSrjVujSXE36BCK5gIHN7rRSEo9TpViZPM8m55dedduk1PgCeaT/KTUr0WP
        w9+AqxWOnkuSfqj+XfvL/XaGJq+czvs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-kaM7C-6POYeJEkH2MyXrxA-1; Wed, 01 Jul 2020 13:42:28 -0400
X-MC-Unique: kaM7C-6POYeJEkH2MyXrxA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C53871940920;
        Wed,  1 Jul 2020 17:42:26 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B13D379220;
        Wed,  1 Jul 2020 17:42:23 +0000 (UTC)
Date:   Wed, 1 Jul 2020 12:41:03 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        linux-mm@kvack.org, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        drbd-dev@tron.linbit.com, dm-devel@redhat.com,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: remove dead bdi congestion leftovers
Message-ID: <20200701164103.GC27063@redhat.com>
References: <20200701090622.3354860-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701090622.3354860-1-hch@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jul 01 2020 at  5:06am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Hi Jens,
> 
> we have a lot of bdi congestion related code that is left around without
> any use.  This series removes it in preparation of sorting out the bdi
> lifetime rules properly.

I could do some git archeology to see what the fs, mm and block core
changes were to stop using bdi congested but a pointer to associated
changes (or quick recap) would save me some time.

Also, curious to know how back-pressure should be felt back up the IO
stack now? (apologies if these are well worn topics, I haven't been
tracking this area of development).

Thanks,
Mike

