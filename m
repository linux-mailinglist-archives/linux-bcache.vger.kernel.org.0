Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E99D1E37D6
	for <lists+linux-bcache@lfdr.de>; Wed, 27 May 2020 07:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgE0FXo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 May 2020 01:23:44 -0400
Received: from verein.lst.de ([213.95.11.211]:48261 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgE0FXo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 01:23:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9937168B02; Wed, 27 May 2020 07:23:41 +0200 (CEST)
Date:   Wed, 27 May 2020 07:23:41 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/16] block: add disk/bio-based accounting helpers
Message-ID: <20200527052341.GA17530@lst.de>
References: <20200525113014.345997-1-hch@lst.de> <20200525113014.345997-2-hch@lst.de> <fafb94a9-cdce-5ea0-e73f-9463766a9f19@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fafb94a9-cdce-5ea0-e73f-9463766a9f19@yandex-team.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, May 25, 2020 at 03:28:07PM +0300, Konstantin Khlebnikov wrote:
> I think it would be better to leave this jiffies legacy nonsense in
> callers and pass here request duration in nanoseconds.

jiffies is what the existing interfaces uses.  But now that they come
from the start helper fixing this will become easier.  I'll do that
as a follow on, as I'd rather not bloat this series even more.
