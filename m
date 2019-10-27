Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642EBE61C5
	for <lists+linux-bcache@lfdr.de>; Sun, 27 Oct 2019 10:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfJ0JP7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 27 Oct 2019 05:15:59 -0400
Received: from s802.sureserver.com ([195.8.222.36]:42216 "EHLO
        s802.sureserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfJ0JP7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 27 Oct 2019 05:15:59 -0400
Received: (qmail 19706 invoked by uid 1003); 27 Oct 2019 09:15:55 -0000
Received: from unknown (HELO ?94.155.37.179?) (zimage@dni.li@94.155.37.179)
  by s802.sureserver.com with ESMTPA; 27 Oct 2019 09:15:55 -0000
Subject: Re: Very slow bcache-register: 6.4TB takes 10+ minutes
To:     linux-bcache@vger.kernel.org
References: <5008cd68-9ec5-5daf-3d56-25ea8b8a7736@del.bg>
 <224a181d-06a6-2517-865d-c71595487187@suse.de>
From:   Teodor Milkov <tm@del.bg>
Message-ID: <6de6d941-6ddf-317a-5b1c-b8210c6581b5@del.bg>
Date:   Sun, 27 Oct 2019 11:15:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <224a181d-06a6-2517-865d-c71595487187@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Just for the record -- here are the times to register a cache device vs. 
how full it is (used % from priority_stats):

||  GB ||     Time || GB/s ||
|  111 |   0m10.8s |  10.3  |
|  209 |   0m20.3s |  10.3  |
|  433 |   0m43.1s |  10.0  |
|  931 |   1m41.6s |   9.2  |
| 1695 |   3m11s   |   8.9  |

This is on Intel DC P3500 series 2TB NVMe drive +
Xeon Silver 4114 CPU @ 2.20GHz.

